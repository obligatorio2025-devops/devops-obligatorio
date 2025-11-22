output "api_gateway_ecr_url" {
  value = module.ecr.repositories["api-gateway"].repository_url
}

output "inventory_service_ecr_url" {
  value = module.ecr.repositories["inventory-service"].repository_url
}

output "product_service_ecr_url" {
  value = module.ecr.repositories["product-service"].repository_url
}
