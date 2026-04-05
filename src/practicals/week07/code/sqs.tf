terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["./credentials"]
}

resource "aws_sqs_queue" "ical_queue" {
    name = "ical"
}

# Output the URL of the ical SQS queue.
# Not needed for the practical, as Celery manages the connection to SQS using AWS credentials.
#output "sqs_url_resource_attribute" {
#  value = aws_sqs_queue.ical_queue.id
#}