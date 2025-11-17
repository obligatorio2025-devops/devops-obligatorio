variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "Subnets where ASG will place instances"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups from the environment"
}


variable "ami_filter" {
  description = "AMI filter pattern"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
} //to do: ver que es esto