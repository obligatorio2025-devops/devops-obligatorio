# VPC
output "vpc_id" {
  description = "VPC ID - Develop"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets IDs - Develop"
  value       = module.vpc.public_subnet_ids
}

# ALB
output "alb_arn" {
  description = "ARN del Application Load Balancer - Develop"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS público del ALB - Develop"
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  description = "ARN del target group del ALB - Develop"
  value       = module.alb.target_group_arn
}


# ECS
output "ecs_cluster_id" {
  description = "Cluster ID - Develop"
  value = module.ecs.cluster_id
}

output "ecs_cluster_name" {
  description = "Cluster nombre - Develop"
  value = module.ecs.cluster_name
}

output "ecs_service_arn" {
  description = "ECS Service arn - Develop"
  value = module.ecs.service_arn
}

output "ecs_service_name" {
  description = "ECS Service nombre - Develop"
  value = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ECS Task definition arn - Develop"
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
