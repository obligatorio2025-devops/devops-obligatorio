## outputs.tf (CORRECCIÓN FINAL DEFINITIVA)

output "ecs_cluster_arn" {
  description = "ARN del ECS Cluster creado."
  value       = module.ecs_fargate_app.cluster_arn 
}

output "ecs_service_name" {
  description = "ID del servicio ECS Fargate creado."
  # Accede al mapa 'services' usando la clave del servicio y obtiene el 'id'
  value       = module.ecs_fargate_app.services[var.service_name].id 
}

output "task_definition_arn" {
  description = "ARN de la Task Definition más reciente."
  # Accede al mapa 'services' usando la clave del servicio y obtiene el 'task_definition_arn'
  value       = module.ecs_fargate_app.services[var.service_name].task_definition_arn
}