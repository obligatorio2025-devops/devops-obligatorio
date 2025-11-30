# Módulo para crear los backups unicamente dedicados a almacenar respaldos que guarda la funcion lambda

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
    Name        = var.bucket_name
  }
}
