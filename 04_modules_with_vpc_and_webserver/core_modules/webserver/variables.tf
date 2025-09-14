variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "Port for the web server to listen on"
  type        = number
  default     = 8080
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
}

variable "environment" {
  description = "The environment name (e.g., stage, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}