// Variables de vpc que usa el modulo

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR block for public subnet"
  type        = list(string) 
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
}


