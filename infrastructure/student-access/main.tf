# resource "github_repository_collaborator" "access" {
#   repository = var.repo
#   username   = var.username
#   permission = "push"
# }

resource "github_repository_file" "folder" {
  repository          = var.repo
  branch              = var.branch
  file                = "${var.sid}/${var.sid}.meta"
  content             = "# Owned by ${var.username}"
  commit_message      = "Provision repository for ${var.sid}"
  commit_author       = "Brae Webb"
  commit_email        = "b.webb@uq.edu.au"
  overwrite_on_create = true
  count               = var.create_folder ? 1 : 0
}

