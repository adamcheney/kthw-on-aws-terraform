locals {
  cidr = [
    join(".", [var.kthw_classb_network, "1.0/24"]),
    join(".", [var.kthw_classb_network, "2.0/24"]),
    join(".", [var.kthw_classb_network, "3.0/24"])
  ]
  availability_zone = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]

}
resource "aws_subnet" "nodes" {
  count             = 3
  cidr_block        = element(local.cidr, count.index)
  availability_zone = element(local.availability_zone, count.index)
  tags = merge(
    map(
      "Name", "KtHW_${element(local.availability_zone, count.index)}",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
