resource "aws_instance" "controller" {
  count                = 3
  ami                  = data.aws_ami.node_base.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  availability_zone    = "${var.aws_region}${element(["a", "b", "c"], count.index)}"
  source_dest_check    = false
  tags = merge(
    map(
      "Name", "KtHW Controller-${count.index}",
      "created-by", var.owner,
      "role", "control",
      "node", "control-${count.index}"
    ),
    var.custom_tags
  )
}
resource "aws_instance" "worker" {
  count                = 3
  ami                  = data.aws_ami.node_base.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  availability_zone    = "${var.aws_region}${element(["a", "b", "c"], count.index)}"
  source_dest_check    = false
  tags = merge(
    map(
      "Name", "KtHW Worker-${count.index}",
      "created-by", var.owner,
      "role", "worker",
      "node", "worker-${count.index}"
    ),
    var.custom_tags
  )
}
