# --------------------------------------------------------------
# IAM readonly access to CodeCommit
# --------------------------------------------------------------
variable "service_role" {
  description = "The IAM role used to provide read-only access to CodeCommit"
  type        = string
  default     = "amplify-codecommit-readonly-role"
}

# --------------------------------------------------------------
# Amplify App variables
# --------------------------------------------------------------
variable "app_name" {
  description = "The name of the Amplify App"
  type        = string
  default     = "Amplify-App"
}

variable "branch_name" {
  description = "The name of the branch to be created"
  type        = string
  default     = "master"
}