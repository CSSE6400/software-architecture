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

locals {
  password = "foobarbaz" # this is bad
}

resource "aws_db_instance" "todoapp-database" {
  maintenance_window      = "Mon:06:00-Mon:09:00"
  backup_window           = "09:01-11:00"
  backup_retention_period = 2

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

resource "aws_db_instance" "todoapp-database-replica1" {
  replicate_source_db = aws_db_instance.todoapp-database.id
  backup_retention_period = 2
  maintenance_window      = "Mon:06:00-Mon:09:00"
  backup_window           = "09:01-11:00"

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
    Name = "todoapp-database-replica1"
  }
}

resource "aws_db_instance" "todoapp-database-replica2" {
  replicate_source_db = aws_db_instance.todoapp-database.id
  backup_retention_period = 2
  maintenance_window      = "Mon:06:00-Mon:09:00"
  backup_window           = "09:01-11:00"

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
    Name = "todoapp-database-replica2"
  }
}
