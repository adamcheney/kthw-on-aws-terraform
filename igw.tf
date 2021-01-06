resource "aws_internet_gateway" "gateway" {
  tags = merge(
    map(
      "Name", "KtHW IGW",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
