// Pasa variables del ambiente (Develop) hacia los módulos

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
<<<<<<< Updated upstream
  region      = var.aws_region
=======
  region = var.aws_region
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
# to do: ajustar
# module "ecs" {
#   source      = "../../modules/ecs"
#   vpc_id      = module.vpc.vpc_id
#   subnet_ids  = module.vpc.public_subnet_ids
#   environment = var.environment
# }

=======
module "alb" {
  source             = "../../modules/alb"
  environment        = var.environment
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  security_group_ids = var.security_group_ids
}

module "ecs" {
  source             = "../../modules/ecs"
  environment        = var.environment
  cluster_name       = var.cluster_name
  service_name       = var.service_name
  desired_count      = var.desired_count
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = module.alb.alb_security_group_ids
  container_image    = var.container_image
  container_port     = var.container_port
}

module "observability" {
  source           = "../../modules/observability"
  region           = var.aws_region
  env              = var.environment
  ecs_cluster_name = module.ecs.cluster_name
  alb_arn_suffix   = module.alb.alb_arn_suffix
}
>>>>>>> Stashed changes
