aws_region           = "us-east-1"
environment          = "testing"
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.0.0/25", "10.1.0.128/25"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
enable_alb           = true
desired_count        = 1
min_count            = 1
max_count            = 3
enable_autoscaling   = true

