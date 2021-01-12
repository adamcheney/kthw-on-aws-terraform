terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # arn:aws:s3:::kthw-tfstate
  backend "s3" {
    encrypt        = true
    bucket         = "kthw-tfstate"
    dynamodb_table = "kthw-statelock"
    key            = "terraform-state/terraform.tfstate"
    # region       = "us-west-2"
  }
}

provider "aws" {}
