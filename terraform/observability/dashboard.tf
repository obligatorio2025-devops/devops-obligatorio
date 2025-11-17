resource "aws_cloudwatch_dashboard" "stockwiz" {
  dashboard_name = "stockwiz-${var.env}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type": "metric", "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "title": "ECS CPU & Memory",
          "region": var.region,
          "metrics": [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name ],
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name ]
          ],
          "period": 60, "view": "timeSeries"
        }
      }
    ]
  })
}
