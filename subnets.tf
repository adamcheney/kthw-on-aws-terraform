resource "aws_subnet" "private_a" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = merge(
    map(
      "Name", "KtHW_prv_A",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
resource "aws_subnet" "private_b" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  tags = merge(
    map(
      "Name", "KtHW_prv_B",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
resource "aws_subnet" "private_c" {
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}c"
  tags = merge(
    map(
      "Name", "KtHW_prv_C",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
resource "aws_subnet" "public_c" {
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}c"
  tags = merge(
    map(
      "Name", "KtHW_pub_C",
      "created-by", var.owner
    ),
    var.custom_tags
  )
  vpc_id = aws_vpc.kthw.id
}
