terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # arn:aws:s3:::kthw-tfstate
  # COPY THESE FROM shared_variables.tf - no variables allowed in backend conf :(
  backend "s3" {
    encrypt        = true
    bucket         = "kthw-tfstate-2"
    dynamodb_table = "kthw-statelock"
    key            = "terraform-state/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}
