terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "./credentials"
}

locals {
  password = "foobarbaz" # this is bad
}

resource "aws_db_instance" "todoapp-database" {
  allocated_storage      = 20
  max_allocated_storage  = 1000
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  name                   = "todoapp"
  username               = "todoapp"
  password               = local.password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.todoapp-database.id]
  publicly_accessible    = true

  tags = {
    Name = "todoapp-database"
  }
}

resource "aws_security_group" "todoapp-database" {
  name        = "todoapp-database"
  description = "Allow inbound MySQL traffic"

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "todoapp-database"
  }
}

resource "aws_security_group" "todoapp-backend" {
  name = "todoapp-backend"
  description = "Todo App HTTP and SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Changes begin here
module "todoapp-template" {
  # changed module from container to template which gives us an aws_launch_template
  source = "git::https://github.com/CSSE6400/terraform//template"
  
  # changed to combined-latest because we split the module into two for the final part of the practical
  image = "ghcr.io/csse6400/todo-app:combined-latest"
  instance_type = "t2.micro"
  environment = {
    APP_ENV="local"
    APP_KEY="base64:8PQEPYGlTm1t3aqWmlAw/ZPwCiIFvdXDBjk3mhsom/A="
    APP_DEBUG="true"
    LOG_LEVEL="debug"
    DB_CONNECTION="mysql"
    DB_HOST=aws_db_instance.todoapp-database.address
    DB_PORT="3306"
    DB_DATABASE="todoapp"
    DB_USERNAME="todoapp"
    DB_PASSWORD=local.password
  }
  ports = {
    "80" = "8000"
  }
  # changed .name to .id as the launch_template needs ids
  security_groups = [aws_security_group.todoapp-backend.id]

  tags = {
    Name = "todoapp-backend"
  }
}

# auto-scaling group
resource "aws_autoscaling_group" "todoapp-group" {
  name = "todoapp"
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = module.todoapp-template.id
    version = "$Latest"
  }
}

# pull all the available subnets on the same vpc as the security group
data "aws_subnet_ids" "nets" {
  vpc_id = aws_security_group.todoapp-backend.vpc_id
}

# our load balancer, attaching same security group as the backend
resource "aws_lb" "todoapp-lb" {
  name               = "todoapp-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.nets.ids
  security_groups    = [aws_security_group.todoapp-backend.id]
}

# target http port 80
resource "aws_lb_target_group" "todoapp-lb" {
  name     = "todoapp-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_security_group.todoapp-backend.vpc_id
}

# forward traffic to previous target group
resource "aws_lb_listener" "todoapp-lb" {
  load_balancer_arn = aws_lb.todoapp-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todoapp-lb.arn
  }
}

# attach load balancer target group to autoscaling group
resource "aws_autoscaling_attachment" "todoapp-lb" {
  autoscaling_group_name = aws_autoscaling_group.todoapp-group.id
  alb_target_group_arn   = aws_lb_target_group.todoapp-lb.arn
}

output "url" {
  value = aws_lb.todoapp-lb.dns_name
}

# data "http" "frontend-page" {
#   url = "https://github.com/CSSE6400/todo-app/releases/download/v0.9.1/index.html"
# }

# resource "random_string" "bucket-name" {
#   length           = 16
#   special = false
#   upper = false
# }

# resource "aws_s3_bucket" "frontend-bucket" {
#   bucket = random_string.bucket-name.result
# }

# resource "aws_s3_bucket_acl" "frontend-bucket" {
#   bucket = aws_s3_bucket.frontend-bucket.bucket
#   acl = "public-read"
# }

# resource "aws_s3_bucket_website_configuration" "frontend-bucket" {
#   bucket = aws_s3_bucket.frontend-bucket.bucket

#   index_document {
#     suffix = "index.html"
#   }
# }

# resource "aws_s3_bucket_object" "frontend-index" {
#   bucket = aws_s3_bucket.frontend-bucket.id
#   key    = "index.html"
#   content_type = "text/html"
#   content = data.http.frontend-page.body
# }

# data "aws_iam_policy_document" "website_policy" {
#   statement {
#     actions = [
#       "s3:GetObject"
#     ]
#     principals {
#       identifiers = ["*"]
#       type = "AWS"
#     }
#     effect = "Allow"
#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.frontend-bucket.id}/*"
#     ]
#   }
# }

# resource "aws_s3_bucket_policy" "allow_public_access" {
#   bucket = aws_s3_bucket.frontend-bucket.id
#   policy = data.aws_iam_policy_document.website_policy.json
# }



# output "url" {
#   value = module.todoapp-backend.public_dns
# }

# output "frontend-url" {
#   value = aws_s3_bucket_website_configuration.frontend-bucket.website_endpoint
# }
