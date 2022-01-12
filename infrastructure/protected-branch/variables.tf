variable "repo" {
  description = "Repository the branch belongs to"
  type = string
}

variable "branch" {
  description = "Repository branch"
  type = string
}

variable "default" {
  description = "Make branch the default"
  type = bool
  default = false
}