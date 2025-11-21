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
  source              = "../../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
  environment         = var.environment
}


module "alb" {
  count       = var.enable_alb ? 1 : 0
  source      = "../../modules/alb"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids    
  environment = var.environment
  security_group_ids = [aws_security_group.alb_sg.id]
}

module "asg" {
  count            = var.enable_asg ? 1 : 0
  source           = "../../modules/asg"
  ami_filter       = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
  environment      = var.environment
  min_size         = var.min_instances
  max_size         = var.max_instances
  desired_capacity = var.desired_instances
  target_group_arn = var.enable_alb ? module.alb[0].target_group_arn : null
  security_group_ids = [aws_security_group.asg_sg.id]
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

resource "aws_security_group" "asg_sg" {
  name        = "${var.environment}-asg-sg"
  description = "Security group for EC2 in ASG"
  vpc_id      = module.vpc.vpc_id

  # Permitir HTTP desde el ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Opcional: SSH solo desde tu IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //to do: es inseguro!! cambiar cuando sepamos que poner
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

# to do: ajustar  
module "ecs" {
  source               = "../../modules/ecs"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnet_ids
}
