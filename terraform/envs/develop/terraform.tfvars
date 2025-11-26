//Asignar los valores reales de las variables

aws_region          = "us-east-1"
environment         = "develop"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]  # dos subnets
azs                 = ["us-east-1a", "us-east-1b"]   

cluster_name    = "stockwiz-develop"
service_name    = "stockwiz-develop-service"
desired_count   = 1
min_capacity    = 1
max_capacity    = 1
container_image = "public.ecr.aws/nginx/nginx:latest"
container_port  = 8000
task_cpu         = 256   
task_memory      = 512 


