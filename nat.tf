resource "aws_eip" "natgw_eip" {
  depends_on = [aws_internet_gateway.gateway]
  vpc        = true
  tags = merge(
    map(
      "Name", "KtHW External IP",
      "created-by", var.owner
    ),
    var.custom_tags
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  tags = merge(
    map(
      "Name", "KtHW NAT Gateway",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.public.id
}
