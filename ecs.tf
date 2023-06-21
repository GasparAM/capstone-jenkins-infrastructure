resource "aws_ecs_cluster" "agents" {
  name = "Jenkins-agents"
}

resource "aws_ecs_cluster_capacity_providers" "agents" {
  cluster_name = aws_ecs_cluster.agents.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_security_group" "agents" {
  vpc_id = aws_vpc.tf.id

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.tf.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}