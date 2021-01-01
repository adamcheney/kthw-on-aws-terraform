variable "kthw_cidr" {
  default = "10.0.0.0/16"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "access_key" {}

variable "secret_key" {}

variable "owner" {
  default = "adamthekiwi@gmail.com"
}

variable "custom_tags" {
  default = {}
}
