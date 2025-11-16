module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
}

