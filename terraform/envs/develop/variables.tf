variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones to use"
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

variable "task_cpu" {
  description = "CPU asignada a la tarea Fargate"
  type        = number
}

variable "task_memory" {
  description = "Memoria asignada a la tarea Fargate (MB)"
  type        = number
}

variable "lambda_name" {
  type = string
}

variable "bucket_name" {
  type = string
}
