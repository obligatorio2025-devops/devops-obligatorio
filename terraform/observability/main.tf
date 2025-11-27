terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_cloudwatch_dashboard" "stockwiz" {
  dashboard_name = "stockwiz-${var.env}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0, width = 12, height = 6,
        properties = {
          title   = "CPU Utilization ECS",
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          stat    = "Average",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      },
      {
        type = "metric",
        x    = 12, y = 0, width = 12, height = 6,
        properties = {
          title   = "Memory Utilization ECS",
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          stat    = "Average",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 6, width = 12, height = 6,
        properties = {
          title   = "Latency ALB",
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat    = "Average",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      },
      {
        type = "metric",
        x    = 12, y = 6, width = 12, height = 6,
        properties = {
          title   = "Requests ALB",
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat    = "Sum",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 12, width = 12, height = 6,
        properties = {
          title   = "Healthy Host Count ALB",
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
          ],
          stat    = "Average",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      },
      {
        type = "metric",
        x    = 12, y = 12, width = 12, height = 6,
        properties = {
          title   = "HTTP 5xx Errors ALB",
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat    = "Sum",
          period  = 300,
          view    = "timeSeries",
          region  = var.region
        }
      }
    ]
  })
}

# SNS topic para notificaciones
resource "aws_sns_topic" "alerts" {
  name = "stockwiz-alerts-${var.env}"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "CE247692@fi365.ort.edu.uy" 
}

# Alarma: cuando CPU esta alta en ECS
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "stockwiz-ecs-cpu-high-${var.env}"
  alarm_description   = "Se dispara si la CPU del ECS supera 80% durante 3 minutos consecutivos"
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

# Alarma: Errores 5xx en ALB
resource "aws_cloudwatch_metric_alarm" "alb_5xx_high" {
  alarm_name          = "stockwiz-alb-5xx-high-${var.env}"
  alarm_description   = "Se dispara si el ALB devuelve más de 10 errores 5xx en 3 minutos"
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

# Suscripción del Lambda al SNS
resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "lambda"
  endpoint  = var.backup_lambda_arn
}


# Permiso para que SNS invoque el Lambda
resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.backup_lambda_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts.arn
}

