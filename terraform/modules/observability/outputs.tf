output "dashboard_name" {
  value       = aws_cloudwatch_dashboard.stockwiz.dashboard_name
  description = "Nombre del dashboard"
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "ecs_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.ecs_cpu_high.arn
}

output "alb_5xx_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.alb_5xx_high.arn
}

output "lb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.this.arn_suffix
}

output "backup_lambda_arn" {
  value = aws_lambda_function.backup_lambda.arn
}

