resource "aws_subnet" "nodes" {
  count             = 3
  cidr_block        = element(local.subnet_cidr, count.index)
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
