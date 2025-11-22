variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "enable_alb" {
  type = bool
}

variable "enable_asg" {
  type = bool
}

variable "min_instances" {
  type = number
}

variable "max_instances" {
  type = number
}

variable "desired_instances" {
  type = number
}

variable "lambda_name" {
  type = string
}

variable "bucket_name" {
  type = string
}
