// Pasa variables del ambiente (Testing) hacia los modulos

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
  source               = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  azs                  = var.azs
}

module "alb" {
  count               = var.enable_alb ? 1 : 0
  source              = "../../modules/alb"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids    
  environment         = var.environment
  security_group_ids  = [aws_security_group.alb_sg.id]
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
  environment   = var.environment
}

# Para cuando esté el modulo ecs
# module "ecs" {
#   source = "../../modules/ecs"

#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnet_ids
#   public_subnets  = module.vpc.public_subnet_ids

#   alb_target_group_arn = var.enable_alb ? module.alb[0].target_group_arn : null

#   desired_count  = var.desired_count
#   min_count      = var.min_count
#   max_count      = var.max_count

#   enable_autoscaling = var.enable_autoscaling

#   service_names = ["api-gateway", "inventory-service", "product-service"]
# }