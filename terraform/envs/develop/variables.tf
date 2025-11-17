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

variable "public_subnet_cidrs" {
  description = "CIDR block for public subnet - develop"
  type        = list(string)
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances for develop"
  type        = number
  default     = 1
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
}

//to do: ver que se pone aca
variable "aws_access_key" {
  type    = string
  default = "FAKE_AWS_KEY"
}

variable "aws_secret_key" {
  type    = string
  default = "FAKE_AWS_SECRET"
}

