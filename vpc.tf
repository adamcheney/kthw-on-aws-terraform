resource "aws_vpc" "kthw" {
  cidr_block = var.kthw_cidr
  tags = merge(
    map(
      "Name", "KtHW VPC",
      "created-by", var.owner
    ),
    var.custom_tags
  )
}
