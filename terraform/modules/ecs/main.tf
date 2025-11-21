terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" 
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_role" "lab_role" {
name = "LabRole"
}


module "ecs_fargate_app" {
  source  = "terraform-aws-modules/ecs/aws" 
  version = "6.9.0"
}