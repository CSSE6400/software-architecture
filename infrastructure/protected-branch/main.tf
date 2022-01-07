resource "github_branch" "branch" {
  repository = var.repo
  branch     = var.branch
}

resource "github_branch_protection" "protection" {
  repository_id = var.repo

  pattern          = github_branch.branch.branch
  enforce_admins   = false
  allows_deletions = false

  allows_force_pushes = false
}

resource "github_branch_default" "default" {
  repository = var.repo
  branch     = var.branch
  count = var.default ? 1 : 0
}
