variable "region" { type = string }
variable "env"    { type = string }
variable "ecs_cluster_name" { type = string }

variable "alb_arn_suffix" {
  description = "ARN suffix del ALB (ej: app/stockwiz-alb/abc123...)"
  type        = string
  default     = ""
}
