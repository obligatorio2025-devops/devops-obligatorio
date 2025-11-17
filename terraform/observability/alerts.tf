resource "aws_sns_topic" "alerts" {
  name = "stockwiz-alerts-${var.env}"
}

# Cambia el email por el tuyo
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "tu-email@ejemplo.com"
}
