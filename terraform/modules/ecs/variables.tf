variable "region" {
  description = "La región de AWS donde se desplegarán los recursos."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nombre para el Cluster ECS."
  type        = string
}

variable "service_name" {
  description = "Nombre para el Servicio ECS."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el servicio."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de subredes privadas para el servicio Fargate."
  type        = list(string)
}

variable "container_image" {
  description = "Imagen del contenedor (ej. Nginx) a desplegar."
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Puerto del contenedor que expone la aplicación."
  type        = number
  default     = 80
}

variable "environment" {
  description = "Nombre del entorno (develop, testing, prod)"
  type        = string
}

variable "desired_count" {
  description = "Número de tareas por defecto"
  type        = number
}

variable "min_capacity" {
  description = "Capacidad mínima de instancias/tareas"
  type        = number
}

variable "max_capacity" {
  description = "Capacidad máxima de instancias/tareas"
  type        = number
}

variable "security_group_ids" {
  description = "Lista de IDs de Security Groups para el servicio ECS/Fargate"
  type        = list(string)
}
