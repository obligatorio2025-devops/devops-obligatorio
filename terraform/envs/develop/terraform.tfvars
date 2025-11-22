//Asignar los valores reales de las variables

aws_region          = "us-east-1"
environment         = "develop"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24"]
instance_count      = 1
instance_type       = "t2.micro"
azs                 = ["us-east-1a"]

cluster_name    = "stockwiz-dev"
service_name    = "stockwiz-dev-service"
desired_count   = 1
min_capacity    = 1
max_capacity    = 1
container_image = "nginx:latest"
container_port  = 80
