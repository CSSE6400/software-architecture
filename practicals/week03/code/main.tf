terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "./credentials"
}

resource "aws_instance" "hextris-server" {
  ami           = "ami-0a8b4cd432b1c3063"
  instance_type = "t2.micro"
  user_data = file("${path.module}/deploy.sh")
  security_groups = [aws_security_group.hextris-server.name]

  tags = {
    Name = "hextris"
  }
}

resource "aws_security_group" "hextris-server" {
  name = "hextris-server"
  description = "Hextris HTTP and SSH access"

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

output "hextris-url" {
  value = aws_instance.hextris-server.public_ip
}
