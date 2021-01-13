resource "aws_vpc_dhcp_options" "foo" {
  domain_name         = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = merge(
    map(
      "Name", "KtHW DHCP Options",
      "created-by", var.owner
    ),
    var.custom_tags
  )
}
