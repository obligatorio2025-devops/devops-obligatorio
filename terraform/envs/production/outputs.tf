# VPC
output "vpc_id" {
  description = "VPC ID - Producción"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets IDs - Producción"
  value       = module.vpc.public_subnet_ids
}

# ALB
output "alb_arn" {
  description = "ARN del Application Load Balancer - Producción"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS público del ALB - Producción"
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  description = "ARN del target group del ALB - Producción"
  value       = module.alb.target_group_arn
}

# ECS
output "ecs_cluster_id" {
  description = "Cluster ID - Producción"
  value = module.ecs.cluster_id
}

output "ecs_cluster_name" {
  description = "Cluster nombre - Producción"
  value = module.ecs.cluster_name
}

output "ecs_service_arn" {
  description = "ECS Service arn - Producción"
  value = module.ecs.service_arn
}

output "ecs_service_name" {
  description = "ECS Service nombre - Producción"
  value = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ECS Task definition arn - Producción"
  value = module.ecs.task_definition_arn
}

# ECR
output "api_gateway_ecr_url" {
  value = module.ecr.repositories["api-gateway"].repository_url
}

output "inventory_service_ecr_url" {
  value = module.ecr.repositories["inventory-service"].repository_url
}

output "product_service_ecr_url" {
  value = module.ecr.repositories["product-service"].repository_url
}

# Backups S3 Bucket para respaldo
output "backups_bucket_name" {
  value = module.backups.bucket_name
}

output "backups_bucket_arn" {
  value = module.backups.bucket_arn
}

# Lambda
output "lambda_name" {
  description = "Nombre de la funcion lambda"
  value       = var.lambda_name
}



