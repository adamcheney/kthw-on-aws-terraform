locals {
  availability_zone = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
  subnet_id = [
    "${aws_subnet.nodes_a.id}",
    "${aws_subnet.nodes_b.id}",
    "${aws_subnet.nodes_c.id}"
  ]
}
resource "aws_instance" "controller" {
  count                = 3
  ami                  = data.aws_ami.node_base.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  availability_zone    = element(local.availability_zone, count.index)
  subnet_id            = element(local.subnet_id, count.index)
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
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  availability_zone    = element(local.availability_zone, count.index)
  subnet_id            = element(local.subnet_id, count.index)
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
