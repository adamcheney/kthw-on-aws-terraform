terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  profile    = "default"
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}
# Create S3 bucket for state file
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "kthw-tfstate"
  versioning {
    # enable with caution, makes deleting S3 buckets tricky
    # very useful for ensuring recovery
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = merge(
    tomap({
      "name" = "KtHW Terraform state remote storage",
      "created-by" = var.owner
    }),
    var.custom_tags
  )
}
# Create DynamoDB table for lock
resource "aws_dynamodb_table" "terraform-state-lock-dynamodb" {
  name           = "kthw-statelock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge(
    tomap({
      "name" = "KtHW Terraform state lock storage",
      "created-by" = var.owner
    }),
    var.custom_tags
  )
}
