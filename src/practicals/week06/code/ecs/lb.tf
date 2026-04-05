resource "aws_lb_target_group" "taskoverflow" {
  name          = "taskoverflow"
  port          = 6400
  protocol      = "HTTP"
  vpc_id        = aws_security_group.taskoverflow.vpc_id
  target_type   = "ip"

  health_check {
    path                = "/api/v1/health"
    port                = "6400"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb" "taskoverflow" {
  name               = "taskoverflow"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.private.ids
  security_groups    = [aws_security_group.taskoverflow_lb.id]
}

resource "aws_security_group" "taskoverflow_lb" {
  name        = "taskoverflow_lb"
  description = "TaskOverflow Load Balancer Security Group"

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  tags = {
    Name = "taskoverflow_lb_security_group"
  }
}

resource "aws_lb_listener" "taskoverflow" {
  load_balancer_arn   = aws_lb.taskoverflow.arn
  port                = "80"
  protocol            = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.taskoverflow.arn
  }
}

output "taskoverflow_dns_name" { 
  value = aws_lb.taskoverflow.dns_name
  description = "DNS name of the TaskOverflow load balancer."
}
