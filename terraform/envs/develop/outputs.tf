output "api_gateway_ecr_url" {
  value = aws_ecr_repository.api_gateway.repository_url
}

output "inventory_service_ecr_url" {
  value = aws_ecr_repository.inventory.repository_url
}

output "product_service_ecr_url" {
  value = aws_ecr_repository.product.repository_url
}
