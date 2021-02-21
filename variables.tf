variable "state_s3bucket" {
  default = "kthw-tfstate"
}
variable "statelock_dynamodb" {
  default = "kthw-statelock"
}
variable "kthw_classb_network" {
  default = "10.240"
}
variable "aws_region" {
  default = "us-west-2"
}
variable "owner" {
  default = "adamthekiwi@gmail.com"
}
variable "custom_tags" {
  default = {}
}
# variable "access_key" {}
# variable "secret_key" {}
variable "instance_type" {
  default = "t3.micro"
}
