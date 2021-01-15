resource "aws_security_group" "kthw_firewall_rules" {
  tags = merge(
    map(
      "Name", "KtHW Firewall",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  name        = "kthw_firewall"
  description = "Allows vpc-internal traffic and HTTPS and ICMP from external"
  vpc_id      = aws_vpc.kthw.id
  ingress {
    description = "All internal to VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.kthw.cidr_block]
  }
  ingress {
    description = "External HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "External HTTPS"
    from_port   = 6443
    to_port     = 6443
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
