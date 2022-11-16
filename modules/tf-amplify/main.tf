# --------------------------------------------------------------
# IAM Policy for the Amplify Service Role
# --------------------------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------
# IAM Role providing read-only access to GitHub
# ----------------------------------------------------------------
resource "aws_iam_role" "codecommit_readonly" {
  name               = var.service_role
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
  ]
}

# ----------------------------------------------------------------
# Getting the GitHub token parameter from the SSM Parameter Store
# ----------------------------------------------------------------
data "aws_ssm_parameter" "github_token" {
  name = "auth_token"
}

# ----------------------------------------------------------------
# Amplify App
# ----------------------------------------------------------------
resource "aws_amplify_app" "app" {
  name                 = var.app_name
  repository           = "https://github.com/tonys31/react-app-auth-amplify.git"
  access_token         = data.aws_ssm_parameter.github_token.value
  iam_service_role_arn = aws_iam_role.codecommit_readonly.arn
  build_spec           = "../../amplify.yml"

  auto_branch_creation_config {
    enable_auto_build = true
  }

  environment_variables = {
    "ENV"             = "Dev"
    "accessKeyId"     = "ACCESS_KEY_ID"
    "secretAccessKey" = "SECRET_KEY"
  }
}

resource "aws_amplify_branch" "branch" {
  app_id      = aws_amplify_app.app.id
  branch_name = var.branch_name

  framework = "REACT"
  stage     = "DEVELOPMENT"
}

resource "aws_amplify_backend_environment" "backend" {
  app_id           = aws_amplify_app.app.id
  environment_name = "dev"
  stack_name       = "amplify-appdev"
}



