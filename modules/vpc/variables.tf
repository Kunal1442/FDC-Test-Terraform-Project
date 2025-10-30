variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block (for example: 10.0.0.0/16)"
  }
}

variable "project_name" {
  description = "The name of the project."
  type        = string
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

variable "tags" {
  description = "Required tags for all resources"
  type        = map(string)
  default = {
    "map-migrated" = "migIGWWU4RWIN"
  }
}
