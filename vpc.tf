resource "aws_vpc" "kthw" {
  cidr_block = local.vpc_cidr
  tags = merge(
    tomap({
      "Name"      = "KtHW VPC",
      "created-by"= var.owner
    }),
    var.custom_tags
  )
  enable_dns_support   = true
  enable_dns_hostnames = true
}
