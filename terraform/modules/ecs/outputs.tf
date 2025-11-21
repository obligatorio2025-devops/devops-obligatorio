output "ecs_cluster_arn" {
  description = "ARN del ECS Cluster creado."
  value       = module.ecs_fargate_app.cluster_arn 
}

output "ecs_service_name" {
  description = "ID del servicio ECS Fargate creado."
  value       = module.ecs_fargate_app.services[var.service_name].id 
}

output "task_definition_arn" {
  description = "ARN de la Task Definition más reciente."
  value       = module.ecs_fargate_app.services[var.service_name].task_definition_arn
}