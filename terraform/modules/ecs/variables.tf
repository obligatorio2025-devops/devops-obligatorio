## Variables.tf

variable "region" {
  description = "La región de AWS donde se desplegarán los recursos."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nombre para el Cluster ECS."
  type        = string
  default     = "fargate-cluster-dev"
}

variable "service_name" {
  description = "Nombre para el Servicio ECS."
  type        = string
  default     = "mi-aplicacion-web-service"
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