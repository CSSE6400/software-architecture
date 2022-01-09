# Assignments where we can freely play with assignments
resource "github_repository" "architecture-assignments" {
  name = "architecture-assignments"
  description = "Software Architecture Assignments"

  visibility = "private"

  has_issues = true
  has_projects = false
  has_wiki = false
}

# Staff access
resource "github_repository_collaborator" "assignments-staff" {
  for_each = toset([ "applebyter" ])
  repository = github_repository.architecture-documentation.name
  username   = each.value
  permission = "admin"
}
