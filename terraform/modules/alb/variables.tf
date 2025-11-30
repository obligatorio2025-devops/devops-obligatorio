variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "container_port" {
  description = "Puerto del contenedor que expone la aplicación"
  type        = number
}