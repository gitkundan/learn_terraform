variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., stage, prod)"
  type        = string
}
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
}

variable "subnet_newbits" {
  description = "Number of bits to add to the VPC CIDR for subnet CIDRs"
  type        = number
}

variable "public_subnet_offset" {
  description = "Offset for public subnet CIDR calculation"
  type        = number
  default     = 0
}

variable "private_subnet_offset" {
  description = "Offset for private subnet CIDR calculation"
  type        = number
  default     = 100
}

variable "azs" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
}