resource "aws_security_group" "kthw_internal" {
  tags = merge(
    map(
      "Name", "KtHW Internal Traffic",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  name        = "allow_int"
  description = "Allow vpc-internal traffic"
  vpc_id      = aws_vpc.kthw.id
  ingress {
    description = "All internal to VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.kthw.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "kthw_external" {
  tags = merge(
    map(
      "Name", "KtHW External Traffic",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  name        = "allow_ext"
  description = "Allow external ssh and ICMP traffic"
  vpc_id      = aws_vpc.kthw.id
  ingress {
    description = "External SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "External SSH"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "External ICMP"
    from_port   = 0
    to_port     = 254
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
