// IAM role for EKS control plane
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-eks-cluster-role"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-eks-cluster-role"
    }
  )

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// Attach EKS cluster policy to control plane role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

// IAM role for EKS worker nodes
resource "aws_iam_role" "eks_nodes" {
  name = "${var.project_name}-eks-node-role"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-eks-node-role"
    }
  )

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// Attach worker node policy to node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

// Attach CNI policy for pod networking
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

// Allow nodes to pull images from ECR
resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

// Security group for EKS cluster control plane
resource "aws_security_group" "cluster" {
  name        = "${var.project_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.eks_cluster_name}-cluster-sg"
    }
  )
}

// Security group rule to allow cluster to communicate with nodes
resource "aws_security_group_rule" "cluster_nodes" {
  description              = "Allow cluster control plane to communicate with nodes"
  from_port               = 443
  protocol                = "tcp"
  security_group_id       = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.nodes.id
  to_port                 = 443
  type                    = "ingress"
}

// Security group for worker nodes
resource "aws_security_group" "nodes" {
  name        = "${var.project_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.eks_cluster_name}-nodes-sg"
    }
  )
}

// Security group rules for worker nodes
resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port               = 0
  protocol                = "-1"
  security_group_id       = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.nodes.id
  to_port                 = 65535
  type                    = "ingress"
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker nodes to receive communication from the cluster control plane"
  from_port               = 1025
  protocol                = "tcp"
  security_group_id       = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.cluster.id
  to_port                 = 65535
  type                    = "ingress"
}

// EKS cluster resource (control plane)
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  
  tags = merge(
    var.tags,
    {
      Name = var.eks_cluster_name
    }
  )

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.cluster.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

// EKS managed node group (worker nodes)
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids
  
  tags = merge(
    var.tags,
    {
      Name = var.eks_node_group_name
    }
  )
  
  # Specify AMI type for Graviton (ARM) instances with Amazon Linux 2023
  ami_type = "AL2023_ARM_64_STANDARD"

  // Add launch template with security groups
  launch_template {
    name    = "${var.project_name}-node-template"
    version = aws_launch_template.eks_nodes.latest_version
  }

  instance_types = var.eks_node_instance_types
  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_launch_template.eks_nodes,
  ]
}

// Launch template for EKS nodes
resource "aws_launch_template" "eks_nodes" {
  name = "${var.project_name}-node-template"

  vpc_security_group_ids = [aws_security_group.nodes.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
  var.tags,
      {
        Name = "${var.project_name}-eks-node"
      }
    )
  }

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -ex
/etc/eks/bootstrap.sh ${aws_eks_cluster.main.name} \
  --container-runtime containerd \
  --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup=${var.eks_node_group_name}'

--==BOUNDARY==--
EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}
