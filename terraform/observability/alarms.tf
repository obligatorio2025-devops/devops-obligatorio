# Alarma ECS CPU > 80%
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ecs-cpu-high-${var.env}"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 3
  period              = 60
  statistic           = "Average"
  dimensions = {
    ClusterName = var.ecs_cluster_name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

# Alarma ALB 5xx (solo si pasás el ARN suffix)
resource "aws_cloudwatch_metric_alarm" "alb_5xx_high" {
  count               = var.alb_arn_suffix == "" ? 0 : 1
  alarm_name          = "alb-5xx-high-${var.env}"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 10
  evaluation_periods  = 3
  period              = 60
  statistic           = "Sum"
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}
