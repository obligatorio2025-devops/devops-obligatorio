// Pasa variables del ambiente (Producción) hacia los modulos

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
  source              = "../../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
  environment         = var.environment
}

module "ecr" {
  source        = "../../modules/ecr"
  service_names = ["api-gateway", "inventory-service", "product-service"]
  environment   = var.environment
}


# Security Group para el ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB in ${var.environment}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tráfico público HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group para ECS / Fargate
resource "aws_security_group" "ecs_sg" {
  name        = "${var.environment}-ecs-sg"
  description = "Security group for ECS tasks in ${var.environment}"
  vpc_id      = module.vpc.vpc_id

  # Permitir tráfico desde el ALB
  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "alb" {
  source      = "../../modules/alb"
  environment = var.environment
  subnet_ids  = module.vpc.public_subnet_ids    
  vpc_id      = module.vpc.vpc_id
  security_group_ids = [aws_security_group.alb_sg.id]
  container_port      = var.container_port
}

module "ecs" {
  source              = "../../modules/ecs"
  vpc_id              = module.vpc.vpc_id 
  environment         = var.environment
  cluster_name        = var.cluster_name
  service_name        = var.service_name
  desired_count       = var.desired_count
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [aws_security_group.ecs_sg.id]  
  container_image     = var.container_image
  container_port      = var.container_port
  task_cpu            = var.task_cpu    
  task_memory         = var.task_memory 
  target_group_arn    = module.alb.target_group_arn
}

module "backups" {
  source      = "../../modules/backups"
  bucket_name = var.bucket_name
  environment = var.environment
}

module "lambda" {
  source        = "../../modules/lambda"
  lambda_name   = var.lambda_name
  bucket_name   = module.backups.bucket_name 
  environment   = var.environment
}

module "observability" {
   source                   = "../../observability"
   region                   = var.aws_region
   env                      = var.environment
   ecs_cluster_name         = module.ecs.cluster_name
   ecs_service_name         = module.ecs.service_name
   alb_arn_suffix           = module.alb.alb_arn_suffix
   target_group_arn_suffix  = module.alb.target_group_arn_suffix
 }
