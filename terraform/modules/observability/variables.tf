variable "region" { type = string }
variable "env"    { type = string }
variable "ecs_cluster_name" { type = string }
variable "ecs_service_name" {type = string }

variable "alb_arn_suffix" {
  type        = string
  default     = ""
}

variable "target_group_arn_suffix" {type = string }

variable "env" {
  type        = string
  description = "Nombre del entorno (ej: develop, prod)"
}

variable "region" {
  type        = string
  description = "Región AWS"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Nombre del cluster ECS"
}

variable "alb_arn_suffix" {
  type        = string
  description = "ARN suffix del ALB"
}
