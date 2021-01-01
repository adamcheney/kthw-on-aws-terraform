# provider "aws" {
#   region = var.aws_region
#   assume_role {
#     role_arn = "arn:aws:iam::185198025243:role/PowerUser"
#   }
# }

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
