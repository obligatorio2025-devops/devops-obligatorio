terraform {
  backend "s3" {
    bucket         = "bucket-develop"
    key            = "develop/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}