resource "aws_instance" "controller" {
  count                       = 3
  ami                         = data.aws_ami.node_base.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  availability_zone           = element(local.availability_zone, count.index)
  subnet_id                   = element(local.subnet_id, count.index)
  private_ip                  = element(local.control_ip, count.index)
  source_dest_check           = false
  associate_public_ip_address = false
  tags = merge(
    tomap({
      "Name"      = "KtHW Controller-${count.index}",
      "created-by"= var.owner,
      "role"      = "control",
      "node"      = "control-${count.index}"
    }),
    var.custom_tags
  )
}
resource "aws_instance" "worker" {
  count                       = 3
  ami                         = data.aws_ami.node_base.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  availability_zone           = element(local.availability_zone, count.index)
  subnet_id                   = element(local.subnet_id, count.index)
  private_ip                  = element(local.worker_ip, count.index)
  source_dest_check           = false
  associate_public_ip_address = false
  tags = merge(
    tomap({
      "Name"      = "KtHW Worker-${count.index}",
      "created-by"= var.owner,
      "role"      = "worker",
      "node"      = "worker-${count.index}"
    }),
    var.custom_tags
  )
}
