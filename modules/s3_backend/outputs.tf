output "key" {
  description = "The KMS key used to encrypt the S3 bucket"
  value      = aws_kms_key.key.arn
}

output "bucket" {
  description = "The S3 bucket used to store the Terraform state"
  value      = aws_s3_bucket.bucket.id
}

output "dynamodb_table" {
  description = "The DynamoDB table used to store the Terraform state lock"
  value      = aws_dynamodb_table.state_lock.name
}