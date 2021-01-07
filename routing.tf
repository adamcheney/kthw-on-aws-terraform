resource "aws_route_table" "kthw_routing" {
  tags = merge(
    map(
      "Name", "KtHW_routing",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}
resource "aws_route_table" "kthw_public" {
  tags = merge(
    map(
      "Name", "KtHW_public",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}
resource "aws_route_table_association" "nodes_a" {
  subnet_id      = aws_subnet.nodes_a.id
  route_table_id = aws_route_table.kthw_routing.id
}
resource "aws_route_table_association" "nodes_b" {
  subnet_id      = aws_subnet.nodes_b.id
  route_table_id = aws_route_table.kthw_routing.id
}
resource "aws_route_table_association" "nodes_c" {
  subnet_id      = aws_subnet.nodes_c.id
  route_table_id = aws_route_table.kthw_routing.id
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.kthw_public.id
}
