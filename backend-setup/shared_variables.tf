variable "aws_region" {
  default = "us-east-1"
}

variable "state_s3bucket" {
  default = "kthw-tfstate" # will need to change to something unique each time
}

variable "access_key" {
}

variable "secret_key" {
}

variable "owner" {
  default = "zachng1@gmail.com"
}

variable "statelock_dynamodb" {
  default = "kthw-statelock"
}

variable "instance-ssh-public-key" {
}