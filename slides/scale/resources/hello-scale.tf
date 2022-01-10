resource "aws_instance" "hello-server" {
  count = 4

  ami           = "ami-04902260ca3d33422"
  instance_type = "t2.micro"
  user_data = file("${path.module}/setup.sh")

  associate_public_ip_address = true
  subnet_id = module.network.subnets[count.index].public.id
  vpc_security_group_ids = [
    module.network.http-port.id
  ]

  tags = {
    Name = "hello-server-${count.index}"
  }
}

resource "aws_lb_target_group" "hello-target" {
  name     = "hello-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc.id

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

resource "aws_lb" "hello-balancer" {
  name               = "hello-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    module.network.subnets[0].public.id,
    module.network.subnets[1].public.id,
    module.network.subnets[2].public.id,
    module.network.subnets[3].public.id
  ]
  security_groups    = [
    module.network.http-port.id
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
