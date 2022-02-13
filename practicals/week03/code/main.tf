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

  tags = {
    Name = "hextris"
  }
}

output "hextris-url" {
  value = aws_instance.hextris-server.public_ip
}
