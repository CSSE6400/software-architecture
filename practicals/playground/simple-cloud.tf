terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "credentials"
}

# Create a VPC
resource "aws_vpc" "uqnet" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name" = "uqnet"
  }
}

resource "aws_security_group" "openweb" {
  name = "openweb"
  vpc_id = aws_vpc.uqnet.id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.uqnet.id
 
  tags = {
    "Name"  = "outside"
  }
}

resource "aws_subnet" "uqnet_public" {
  vpc_id = aws_vpc.uqnet.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "uqnet_public"
  }
}

resource "aws_route_table" "routes" {
  vpc_id = aws_vpc.uqnet.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
 
  tags = {
    "Name"  = "routes"
  }
}

resource "aws_route" "gateway_route" {
  route_table_id = aws_route_table.routes.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public_route" {
  route_table_id = aws_route_table.routes.id
  subnet_id = aws_subnet.uqnet_public.id
}

# resource "aws_route_table_association" "link_outside" {
#   subnet_id = aws_subnet.uqnet_subnet.id
#   route_table_id = aws_route_table.routes.id
# }

resource "aws_instance" "server" {
  ami           = "ami-04902260ca3d33422"
  instance_type = "t2.micro"
  user_data = file("${path.module}/setup.sh")

  associate_public_ip_address = true
  
  subnet_id = aws_subnet.uqnet_public.id

  vpc_security_group_ids = [
    aws_security_group.openweb.id
  ]
  depends_on = [ aws_security_group.openweb ]

  tags = {
    Name = "WebServer"
  }
}


output "domain" {
  value = aws_instance.server.public_dns
}
output "ip" {
  value = aws_instance.server.public_ip
}