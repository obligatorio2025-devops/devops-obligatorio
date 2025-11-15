// Variables de vpc que usa el modulo

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet - develop"
  type        = string
}

variable "environment" {
  description = "Develop"
  type        = string
}