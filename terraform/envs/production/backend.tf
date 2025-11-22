terraform {
  backend "s3" {
    bucket         = "bucket-production-1768"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}