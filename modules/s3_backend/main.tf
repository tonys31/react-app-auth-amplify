# --------------------------------------------------------------
# KMS Key
# --------------------------------------------------------------
resource "aws_kms_key" "key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation
}

# --------------------------------------------------------------
# S3 Bucket Configuration
# --------------------------------------------------------------
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --------------------------------------------------------------
# IAM Policy
# --------------------------------------------------------------
resource "aws_iam_policy" "policy" {
  name = var.policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:ListBucket", "s3:GetBucketVersioning"],
        "Resource" : "arn:aws:s3:::var.bucket_name"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        "Resource" : "arn:aws:s3:::var.bucket_name/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ],
        "Resource" : "${aws_dynamodb_table.state_lock.arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:ListKeys"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ],
        "Resource" : "${aws_kms_key.key.arn}"
      },
    ]
  })
}

# --------------------------------------------------------------
# DynamoDB Table
# --------------------------------------------------------------
locals {
  lock_key_id = "LockID"
}

resource "aws_dynamodb_table" "state_lock" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.lock_key_id

  attribute {
    name = local.lock_key_id
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# --------------------------------------------------------------
# Calling the amplify module
# --------------------------------------------------------------
module "amplify" {
  source = "../tf-amplify"
}