output "aws_iam_role" {
  description = "The IAM role used to provide read-only access to CodeCommit"
  value       = aws_iam_role.codecommit_readonly.arn
}