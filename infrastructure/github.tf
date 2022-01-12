terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

variable "owner" {
  type = string
  default = "BraeWebb" # change when org is made
}

provider "github" {
  owner = var.owner
}

variable "students" {
  type = list
}
