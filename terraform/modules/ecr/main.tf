resource "aws_ecr_repository" "repos" {
  for_each = toset(var.service_names)
  # Nombre del repositorio con entorno + servicio
  name = "${var.environment}-${each.value}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    project = "stockwiz"
    environment = var.environment
    service     = each.value
  }
}

