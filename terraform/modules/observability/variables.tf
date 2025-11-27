variable "region" { type = string }
variable "env"    { type = string }
variable "ecs_cluster_name" { type = string }
variable "ecs_service_name" {type = string }

variable "alb_arn_suffix" {
  type        = string
  default     = ""
}

variable "target_group_arn_suffix" {type = string }

variable "ecs_cluster_name" {
  type        = string
}

variable "alb_arn_suffix" {
  type        = string
}
