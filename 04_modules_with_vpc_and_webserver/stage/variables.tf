# Networking configuration variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
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
  default     = ["us-east-1a", "us-east-1b"] # Add default AZs
}

# webserver section
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of instances in Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
  default     = 4
}

variable "server_port" {
  description = "Port for the web server to listen on"
  type        = number
  default     = 8080
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}