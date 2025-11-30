terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
        }
    }
} 

data "aws_iam_role" "lab_role" {
    name = "LabRole"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir = "${path.module}/backup_prod"
  output_path = "./product-service-backup.zip"
}

resource "aws_lambda_function" "backup_lambda" {
  function_name = var.lambda_name
  role          = data.aws_iam_role.lab_role.arn

  filename         = data.archive_file.zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  handler = "lambda_handler.handler"
  runtime = "python3.13"
  timeout = 10

  environment {
    variables = {
      BACKUP_BUCKET = var.bucket_name
    }
  }
}

resource "aws_lambda_function_url" "python-backup-url" {
  function_name  = aws_lambda_function.backup_lambda.function_name
  authorization_type  = "NONE"    
}
