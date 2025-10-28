variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use."
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
}

variable "eks_node_instance_types" {
  description = "The instance types for the EKS nodes."
  type        = list(string)
}

variable "eks_node_desired_size" {
  description = "The desired number of nodes in the EKS node group."
  type        = number
}

variable "eks_node_max_size" {
  description = "The maximum number of nodes in the EKS node group."
  type        = number
}

variable "eks_node_min_size" {
  description = "The minimum number of nodes in the EKS node group."
  type        = number
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "poc"
    Project     = "eks-poc"
    Owner       = "terraform"
    Purpose     = "testing"
    Managed_by  = "terraform"
  }
}
