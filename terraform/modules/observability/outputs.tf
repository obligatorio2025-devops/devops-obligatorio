output "dashboard_name" {
  value       = aws_cloudwatch_dashboard.stockwiz.dashboard_name
  description = "Nombre del dashboard"
}

output "log_groups" {
  value       = [for k, lg in aws_cloudwatch_log_group.service : lg.name]
  description = "Log groups creados"
}
