
variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets."
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "eks-poc-cluster"
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "eks-poc-node-group"
}

variable "eks_node_instance_types" {
  description = "The instance types for the EKS nodes."
  type        = list(string)
  default     = ["m6g.8xlarge", "r6g.8xlarge", "c6g.8xlarge"]
}

variable "eks_node_desired_size" {
  description = "The desired number of nodes in the EKS node group."
  type        = number
  default     = 4
}

variable "eks_node_max_size" {
  description = "The maximum number of nodes in the EKS node group."
  type        = number
  default     = 5
}

variable "eks_node_min_size" {
  description = "The minimum number of nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}
