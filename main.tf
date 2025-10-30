
module "vpc" {
  source = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags          = var.tags
}

module "eks" {
  source = "./modules/eks"
  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_cluster_name        = var.eks_cluster_name
  eks_node_group_name     = var.eks_node_group_name
  eks_node_instance_types = var.eks_node_instance_types
  eks_node_desired_size   = var.eks_node_desired_size
  eks_node_max_size       = var.eks_node_max_size
  eks_node_min_size       = var.eks_node_min_size
  tags             = var.tags
}
