output "vpc_id" {
  description = "VPC ID - Develop"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID - Develop"
  value       = aws_subnet.public.id
}

output "vpc_cidr" {
  description = "VPC CIDR block - Develop"
  value       = aws_vpc.main.cidr_block
}