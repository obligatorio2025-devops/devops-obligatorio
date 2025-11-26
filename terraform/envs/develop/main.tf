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
  region      = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"
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
    cidr_blocks = ["0.0.0.0/0"] # tráfico público HTTP
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

  # Permitir tráfico desde el ALB en puerto 8000
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Permitir comunicación entre contenedores PostgreSQL
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Permitir comunicación entre contenedores Redis
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Permitir comunicación entre contenedores Product Service
  ingress {
    from_port       = 8001
    to_port         = 8001
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Permitir comunicación entre contenedores Inventory Service
  ingress {
    from_port       = 8002
    to_port         = 8002
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "alb" {
  source              = "../../modules/alb"
  environment         = var.environment
  subnet_ids          = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  security_group_ids  = [aws_security_group.alb_sg.id]
  container_port      = var.container_port
}

locals {
  container_definitions = jsonencode([
    # PostgreSQL
    {
      name      = "postgres"
      image     = "postgres:15"
      essential = true
      portMappings = [
        {
          containerPort = 5432
          protocol      = "tcp"
        }
      ]
      #To do: pasar a secrets
      environment = [
        {name  = "POSTGRES_DB", value = "microservices_db"},
        {name  = "POSTGRES_USER", value = "admin"},
        {name  = "POSTGRES_PASSWORD", value = "admin123"}
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "pg_isready -U admin -d microservices_db"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },
    
    # Redis
    {
      name      = "redis"
      image     = "redis:7-alpine"
      essential = true
      portMappings = [
        {
          containerPort = 6379
          protocol      = "tcp"
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "redis-cli ping"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },

    # Product Service (Python)
    {
      name      = "product-service"
      image     = "${module.ecr.repositories["product-service"].repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8001
          protocol      = "tcp"
        }
      ]
      environment = [
        {name  = "DATABASE_URL", value = "postgresql://admin:admin123@localhost:5432/microservices_db"},
        {name  = "REDIS_URL", value = "redis://localhost:6379"},
        {name  = "PORT", value = "8001"}
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.cluster_name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "product-service"
        }
      }
      dependsOn = [
        {containerName = "postgres", condition = "HEALTHY"},
        {containerName = "redis", condition = "HEALTHY"}
      ]
    },

    # Inventory Service (Go)
    {
      name      = "inventory-service"
      image     = "${module.ecr.repositories["inventory-service"].repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8002
          protocol      = "tcp"
        }
      ]
      environment = [
        {name  = "DATABASE_URL", value = "postgres://admin:admin123@localhost:5432/microservices_db?sslmode=disable"},
        {name  = "REDIS_URL", value = "localhost:6379"}
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.cluster_name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "inventory-service"
        }
      }
      dependsOn = [
        {containerName = "postgres", condition = "HEALTHY"},
        {containerName = "redis", condition = "HEALTHY"}
      ]
    },

    # API Gateway (Go)
    {
      name      = "api-gateway"
      image     = "${module.ecr.repositories["api-gateway"].repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {name  = "ENVIRONMENT", value = var.environment},
        {name  = "REDIS_URL", value = "localhost:6379"},
        {name  = "PRODUCT_SERVICE_URL", value = "http://localhost:8001"},
        {name  = "INVENTORY_SERVICE_URL", value = "http://localhost:8002"}
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.cluster_name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "api-gateway"
        }
      }
      dependsOn = [
        {containerName = "postgres", condition = "HEALTHY"},
        {containerName = "redis", condition = "HEALTHY"},
        {containerName = "product-service", condition = "START"},
        {containerName = "inventory-service", condition = "START"}
      ]
    }
  ])
}

module "ecs" {
  source              = "../../modules/ecs"
  region              = var.aws_region
  environment         = var.environment
  cluster_name        = var.cluster_name
  service_name        = var.service_name
  desired_count       = var.desired_count
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [aws_security_group.ecs_sg.id]  
  container_port      = 8000
  task_cpu            = var.task_cpu    
  task_memory         = var.task_memory 
  target_group_arn    = module.alb.target_group_arn
  container_definitions = local.container_definitions
  vpc_id              = module.vpc.vpc_id
}

# module "observability" {
#   source           = "../../modules/observability"
#   region           = var.aws_region
#   env              = var.environment
#   ecs_cluster_name = module.ecs.cluster_name
#   alb_arn_suffix   = module.alb.alb_arn_suffix
# }
