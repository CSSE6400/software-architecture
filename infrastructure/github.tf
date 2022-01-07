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

variable "students" {
  type = list
}

provider "github" {
  owner = var.owner
}

# Documentation assignment repo
resource "github_repository" "architecture-documentation" {
  name = "architecture-documentation"
  description = "Software Architecture Documentation"

  visibility = "private"

  has_issues = true
  has_projects = false
  has_wiki = false

  auto_init = true
}

# Configure main branch
module "main" {
  source = "./protected-branch"
  repo = github_repository.architecture-documentation.name
  branch = "main"
  default = true
}

module "release" {
  source = "./protected-branch"
  repo = github_repository.architecture-documentation.name
  branch = "release"
}

# Staff access
resource "github_repository_collaborator" "staff" {
  for_each = toset([ "applebyter" ])
  repository = github_repository.architecture-documentation.name
  username   = each.value
  permission = "admin"
}

module "student-access" {
  source = "./student-access"

  repo = github_repository.architecture-documentation.name

  for_each = {for student in var.students:  student.sid => student}

  username = each.value.username
  sid = each.value.sid
  create_folder = true
}
