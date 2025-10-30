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

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block (for example: 10.0.0.0/16)"
  }
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "public_subnet_cidrs must contain the same number of entries as availability_zones"
  }
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "private_subnet_cidrs must contain the same number of entries as availability_zones"
  }
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

  validation {
    condition     = var.eks_node_min_size <= var.eks_node_desired_size && var.eks_node_desired_size <= var.eks_node_max_size
    error_message = "eks_node_min_size <= eks_node_desired_size <= eks_node_max_size must hold"
  }
}

variable "eks_node_max_size" {
  description = "The maximum number of nodes in the EKS node group."
  type        = number
}

variable "eks_node_min_size" {
  description = "The minimum number of nodes in the EKS node group."
  type        = number
}

variable "tags" {
  description = "Required tags for all resources"
  type        = map(string)
  default = {
    "map-migrated" = "migIGWWU4RWIN"
  }
}

// Optional provider-related / helper variables
variable "aws_profile" {
  description = "Optional AWS CLI profile name to use for the provider (leave empty to use env credentials)."
  type        = string
  default     = ""
}

variable "aws_assume_role_arn" {
  description = "Optional role ARN to assume; if empty provider will not assume role."
  type        = string
  default     = ""
}

variable "eks_kubernetes_version" {
  description = "Optional EKS Kubernetes version (leave empty to let AWS choose the default)."
  type        = string
  default     = ""
}
