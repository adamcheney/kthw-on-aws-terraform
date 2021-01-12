variable "node_instance_type" {
  default = "t2.micro"
}
variable "state_s3bucket" {
  default = "kthw-tfstate"
}
variable "statelock_dynamodb" {
  default = "kthw-statelock"
}
variable "kthw_cidr" {
  default = "10.0.0.0/16"
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
variable "custom_asg_tags" {
  default = []
}
