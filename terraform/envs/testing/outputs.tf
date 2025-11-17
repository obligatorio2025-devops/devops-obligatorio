output "vpc_id" {
  description = "VPC ID - Develop"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets IDs - Testing"
  value       = module.vpc.public_subnet_ids
}
