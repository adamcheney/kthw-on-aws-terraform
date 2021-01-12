data "aws_ami" "node_base" {
  most_recent = true
  name_regex  = "focal-20.04"
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-minimal*"]
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
resource "aws_key_pair" "node_key" {
  key_name   = "node-key"
  public_key = file(pathexpand("~/.ssh/kthw-node.pub"))
}
# resource "aws_instance" "ssm_test" {
#   ami                  = data.aws_ami.node_base.id
#   instance_type        = "t2.micro"
#   key_name             = aws_key_pair.node_key.key_name
#   user_data            = file("${path.module}/userdata.sh")
#   iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
# }
resource "aws_launch_template" "node_template" {
  name_prefix   = "node"
  image_id      = data.aws_ami.node_base.image_id
  instance_type = var.node_instance_type
  key_name      = aws_key_pair.node_key.key_name
  user_data     = filebase64("${path.module}/userdata.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }
}
resource "aws_autoscaling_group" "controllers" {
  name               = "KtHW Controllers"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  desired_capacity   = 3
  max_size           = 3
  min_size           = 3
  launch_template {
    id      = aws_launch_template.node_template.id
    version = "$Latest"
  }
  tags = concat(
    [
      {
        key                 = "Name"
        value               = "KtHW controller node"
        propagate_at_launch = true
      },
      {
        key                 = "created-by"
        value               = var.owner
        propagate_at_launch = true
      }
    ],
    var.custom_asg_tags
  )
}
# resource "aws_autoscaling_group" "workers" {
#   availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
#   desired_capacity   = 3
#   max_size           = 3
#   min_size           = 3
#   launch_template {
#     id      = aws_launch_template.node_template.id
#     version = "$Latest"
#   }
#   tags = [merge(
#     map(
#       "Name", "KtHW worker node",
#       "created-by", var.owner
#     ),
#     var.custom_tags
#   )]
# }
