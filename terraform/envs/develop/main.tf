// Pasa variables del ambiente (Develop) hacia los modulos

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region      = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  environment         = var.environment
  azs                 = var.azs
}

module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
  environment   = var.environment
}

# to do: ajustar
# module "ecs" {
#   source      = "../../modules/ecs"
#   vpc_id      = module.vpc.vpc_id
#   subnet_ids  = module.vpc.public_subnet_ids
#   environment = var.environment
# }

