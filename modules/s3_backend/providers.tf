terraform {
  required_version = ">= 1.1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.3"
    }
  }

  backend "s3" {
    key            = "terraform/state"
    region         = "eu-west-1"
    bucket         = "tf-amplify-s3-backend-bucket"
    dynamodb_table = "tf-amplify-backend-dynamodb-lock-table"
  }
}

