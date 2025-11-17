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

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  environment         = var.environment
  azs                 = var.azs
}

module "ec2_instances" {
  source = "../../modules/ec2"

  instance_count = var.instance_count
  instance_type  = var.instance_type
  subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
}

module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
  environment   = var.environment
}
