terraform {
  backend "s3" {
    bucket         = "bucket-testing-9268"
    key            = "testing/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}