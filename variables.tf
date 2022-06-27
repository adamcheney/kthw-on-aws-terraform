variable "kthw_classb_network" {
  default = "10.240"
}
variable "custom_tags" {
  default = {}
}
variable "instance_type" {
  default = "t3.micro"
}

variable "instance-ssh-public-key" {
}

variable "ssh_ip_allowed" {
}
