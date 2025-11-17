data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name" //to do: ver que nombre poner
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "app" {
  name = "${var.environment}-launch-template"

  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  //to do: user_data temporal
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx

    # Página principal
    echo "Hello from ASG" | sudo tee /var/www/html/index.html

    # Endpoint health check
    echo "OK" | sudo tee /var/www/html/health

    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF
    )

  network_interfaces {
    security_groups = var.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name             = "${var.environment}-asg"
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.subnet_ids

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arn != "" ? [var.target_group_arn] : []

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-instance"
    propagate_at_launch = true
  }
}
