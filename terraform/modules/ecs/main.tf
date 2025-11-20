# main.tf (CORRECT)

# 1. The 'terraform' block for global settings (like provider requirements)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # CORREGIDO: Ahora permite versiones 6.x
      version = "~> 6.0" 
    }
  }
}

# 2. Other top-level blocks like 'provider' (if not already defined)
provider "aws" {
  region = "us-east-1"
}

# --- This is the key change ---
# 3. The 'module' block must be a top-level block, outside of 'terraform'
module "ecs_fargate_app" {
  source  = "terraform-aws-modules/ecs/aws" # Fuente EXTERNA de Terraform Registry
  version = "6.9.0"
  # ...
}