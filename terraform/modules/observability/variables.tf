variable "region" { type = string }
variable "environment" { type = string }
variable "ecs_cluster_name" { type = string }
variable "ecs_service_name" {type = string }
variable "alb_arn_suffix" { type = string }
variable "target_group_arn_suffix" { type = string }
variable "backup_lambda_arn" {
  type        = string
  description = "ARN del Lambda de backup"
}
