aws_region          = "us-east-1"
environment         = "testing"
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.0.0/25", "10.1.0.128/25"]
azs = ["us-east-1a", "us-east-1b"]

cluster_name    = "stockwiz-testing"
service_name    = "stockwiz-testing-service"
desired_count   = 1
min_capacity    = 1
max_capacity    = 2
container_image = "nginx:latest"
container_port  = 80
task_cpu         = 256   
task_memory      = 512 
