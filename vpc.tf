resource "aws_vpc" "kthw" {
  cidr_block = var.kthw_cidr
  tags = merge(
    map(
      "Name", "KtHW VPC",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  enable_dns_support   = true
  enable_dns_hostnames = true
}
