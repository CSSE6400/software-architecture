resource "aws_instance" "hello-server" {
  count = 4

  ami           = "ami-04902260ca3d33422"
  instance_type = "t2.micro"
  user_data = file("${path.module}/setup.sh")

  security_groups = [
    aws_security_group.hello-server.name
  ]

  tags = {
    Name = "hello-server-${count.index}"
  }
}

resource "aws_lb_target_group" "hello-target" {
  name     = "hello-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_security_group.hello-server.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "hello-target-link" {
  count            = length(aws_instance.hello-server)
  target_group_arn = aws_lb_target_group.hello-target.arn
  target_id        = aws_instance.hello-server[count.index].id
  port             = 80
}

data "aws_subnet_ids" "nets" {
    vpc_id = aws_security_group.hello-server.vpc_id
}

resource "aws_lb" "hello-balancer" {
  name               = "hello-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet_ids.nets.ids
  security_groups    = [
    aws_security_group.hello-server.name
  ]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.hello-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hello-target.arn
  }
}
