output "vpc_id" {
  description = "VPC ID - Develop"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID - Develop"
  value       = module.vpc.public_subnet_id
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = module.ec2_instances.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = module.ec2_instances.public_ips
}