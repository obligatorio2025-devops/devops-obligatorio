terraform {
  backend "s3" {
    bucket         = "bucket-testing"
    key            = "testing/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}