output "autoscaling_group_name" {
  description = "Autoscaling group name"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.app.id
}
