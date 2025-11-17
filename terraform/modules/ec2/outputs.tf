output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.app[*].id
}

output "public_ips" {
  description = "Public IPs of EC2 instances"
  value       = aws_instance.app[*].public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.instance.id
}