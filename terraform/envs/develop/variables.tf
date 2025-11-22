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

variable "security_group_ids" {
  description = "Lista de IDs de Security Groups para el ALB/ECS"
  type        = list(string)
}

variable "cluster_name" {
  description = "Nombre del cluster ECS"
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio ECS"
  type        = string
}

variable "desired_count" {
  description = "Número de tareas por defecto"
  type        = number
}

variable "min_capacity" {
  description = "Capacidad mínima de tareas"
  type        = number
}

variable "max_capacity" {
  description = "Capacidad máxima de tareas"
  type        = number
}

variable "container_image" {
  description = "Imagen del contenedor"
  type        = string
}

variable "container_port" {
  description = "Puerto expuesto por el contenedor"
  type        = number
}
