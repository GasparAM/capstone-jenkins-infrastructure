resource "aws_ecs_cluster" "agents" {
  name = "Jenkins-agents"
}

# resource "aws_ecs_cluster_capacity_providers" "agents" {
#   cluster_name = aws_ecs_cluster.agents.name

#   capacity_providers = ["FARGATE"]

#   default_capacity_provider_strategy {
#     weight            = 100
#     capacity_provider = "FARGATE"
#   }
# }

# resource "aws_ecs_cluster_capacity_providers" "ec2" {
#   cluster_name = aws_ecs_cluster.agents.name

#   default_capacity_provider_strategy {
#     capacity_provider = aws_ecs_capacity_provider.test.name
#     base              = 1
#     weight            = 100
#   }
# }

resource "aws_ecs_capacity_provider" "test" {
  name = "agents"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.agents.arn
    # managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_launch_template" "agents" {
  name_prefix   = "Terraform-ec"
  image_id      = "ami-05d5bc60fb83bf238"
  instance_type = "t3.medium"
  key_name               = "xosqi"
  vpc_security_group_ids = [aws_security_group.agents.id]
  iam_instance_profile {
    name = "Ec2roleForECS"
  }
  user_data = base64encode(file("./ecsdata.sh"))

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "agents" {
  # desired_capacity   = 1
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]

  launch_template {
    id      = aws_launch_template.agents.id
    version = "$Latest"
  }
}

resource "aws_security_group" "agents" {
  vpc_id = aws_vpc.tf.id

  ingress {
    description     = "HTTP"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.tf.id]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ingress_ips
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_autoscaling_policy" "asg" {
  autoscaling_group_name = aws_autoscaling_group.agents.name
  name                   = "agentScaling"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
