variable "username" {
  description = "Github username of the student"
  type        = string
}

variable "sid" {
  description = "Student identifier"
  type = string
}

variable "repo" {
  description = "Repository to provide access to"
  type = string
}

variable "create_folder" {
  description = "Create a folder for the student in Github repo"
  type = bool
  default = false
}

variable "branch" {
  description = "Branch to create folder on"
  type = string
  default = "main"
}