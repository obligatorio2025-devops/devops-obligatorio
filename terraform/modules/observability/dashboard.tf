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
