// Variables del ambiente (Develop)

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Develop"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC - develop"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet - develop"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances for develop"
  type        = number
  default     = 2
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}