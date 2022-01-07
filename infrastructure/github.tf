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
resource "github_branch" "main" {
  repository = github_repository.architecture-documentation.name
  branch     = "main"
}

resource "github_branch" "release" {
  repository = github_repository.architecture-documentation.name
  branch = "release"
}

resource "github_branch_default" "default"{
  repository = github_repository.architecture-documentation.name
  branch     = github_branch.main.branch
}

resource "github_branch_protection" "protect_main" {
  repository_id = github_repository.architecture-documentation.name

  pattern          = github_branch.main.branch
  enforce_admins   = false
  allows_deletions = false

  allows_force_pushes = false
}

resource "github_branch_protection" "protect_release" {
  repository_id = github_repository.architecture-documentation.name

  pattern          = github_branch.release.branch
  enforce_admins   = false
  allows_deletions = false

  allows_force_pushes = false
}

# Staff access
# resource "github_repository_collaborator" "brae" {
#   repository = github_repository.architecture-documentation.name
#   username   = "braewebb"
#   permission = "admin"
# }

resource "github_repository_collaborator" "richo" {
  repository = github_repository.architecture-documentation.name
  username   = "applebyter"
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