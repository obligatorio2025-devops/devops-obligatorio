aws_region          = "us-east-1"
environment         = "production"
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidrs = ["10.2.0.0/24", "10.2.1.0/24"]
azs = ["us-east-1a", "us-east-1b"]

cluster_name    = "stockwiz-production"
service_name    = "stockwiz-production-service"
desired_count   = 2
min_capacity    = 2
max_capacity    = 6
container_image = "nginx:latest"
container_port  = 80
task_cpu         = 256   
task_memory      = 512 


bucket_name       = "backups-prod-456"
lambda_name       = "product-backup-lambda"
