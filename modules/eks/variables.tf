
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

variable "eks_kubernetes_version" {
  description = "Optional EKS Kubernetes version (leave empty to let AWS choose the default)."
  type        = string
  default     = ""
}
