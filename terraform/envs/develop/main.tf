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
  //access_key  = var.aws_access_key
  //secret_key  = var.aws_secret_key
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  azs                  = var.azs
}

module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
  environment   = var.environment
}

# Para cuando esté el modulo ecs
# module "ecs" {
#   source = "../../modules/ecs"

#   cluster_name   = "${var.environment}-cluster"
#   vpc_id         = module.vpc.vpc_id
#   public_subnets = module.vpc.public_subnet_ids
#   private_subnets = [module.vpc.private_subnet_ids[0]] # develop usa una sola
#   environment    = var.environment
# }

