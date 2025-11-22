output "lambda_url" {
  description = "URL de la función Lambda para respaldar el main.py de product-service de prod."
  value       = aws_lambda_function_url.python-backup-url.function_url
}   