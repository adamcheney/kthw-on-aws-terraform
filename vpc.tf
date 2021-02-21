locals {
  cidr = join(".", [var.kthw_classb_network, "0.0/16"])
}

resource "aws_vpc" "kthw" {
  cidr_block = local.cidr
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
