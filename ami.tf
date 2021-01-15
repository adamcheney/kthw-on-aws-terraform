data "aws_ami" "node_base" {
  most_recent = true
  # name_regex  = "focal-20.04"
  owners = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn-ami-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
