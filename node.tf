resource "aws_key_pair" "kthw" {
  key_name = "deployer-key"
  public_key = var.instance-ssh-public-key
}

resource "aws_instance" "controller" {
  count                       = 3
  ami                         = data.aws_ami.node_base.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  availability_zone           = element(local.availability_zone, count.index)
  subnet_id                   = element(local.subnet_id, count.index)
  private_ip                  = element(local.control_ip, count.index)
  source_dest_check           = false
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.kthw_firewall_rules.id]
  key_name = aws_key_pair.kthw.key_name
  tags = merge(
    tomap({
      "Name"      = "KtHW Controller-${count.index}",
      "created-by"= var.owner,
      "role"      = "control",
      "node"      = "control-${count.index}"
    }),
    var.custom_tags
  )

  user_data = "${file("user-data/controller-user-data.sh")}name=control-${count.index}"

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
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.kthw_firewall_rules.id]
  key_name = aws_key_pair.kthw.key_name
  tags = merge(
    tomap({
      "Name"      = "KtHW Worker-${count.index}",
      "created-by"= var.owner,
      "role"      = "worker",
      "node"      = "worker-${count.index}"
    }),
    var.custom_tags
  )

  user_data = "name=worker-${count.index}|pod-cidr=10.200.${count.index}.0/24"
}
