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
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  environment        = var.environment
}

module "ec2_instances" {
  source = "./modules/ec2"

  instance_count = var.instance_count
  instance_type  = var.instance_type
  subnet_id      = module.vpc.public_subnet_id
  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
}