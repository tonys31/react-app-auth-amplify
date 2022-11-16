# --------------------------------------------------------------
# KMS Key
# --------------------------------------------------------------
variable "kms_key_description" {
  description = "The description of the KMS key as it appears in AWS console"
  type        = string
  default     = "KMS key for S3 backend"
}

variable "deletion_window_in_days" {
  description = "The number of days after which the key is deleted after destruction of the resource, must be between 7 and 30 days"
  type        = number
  default     = 30
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

# --------------------------------------------------------------
# S3 Bucket
# --------------------------------------------------------------
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "tf-amplify-s3-backend-bucket"
}

# --------------------------------------------------------------
# IAM Policy
# --------------------------------------------------------------
variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "tf-amplify-s3-backend-policy"
}

# --------------------------------------------------------------
# DynamoDB Table
# --------------------------------------------------------------
variable "dynamodb_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "tf-amplify-backend-dynamodb-lock-table"
}