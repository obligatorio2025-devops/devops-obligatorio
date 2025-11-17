locals {
  services       = ["cart", "checkout", "catalog"]
  retention_days = 14
}

resource "aws_cloudwatch_log_group" "service" {
  for_each          = toset(local.services)
  name              = "/stockwiz/${each.key}-${var.env}"
  retention_in_days = local.retention_days
}
