locals {
  availability_zone = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
  subnet_id = [
    aws_subnet.nodes[0].id,
    aws_subnet.nodes[1].id,
    aws_subnet.nodes[2].id
  ]
  control_ip = [
    join(".", [var.kthw_classb_network, "1.10"]),
    join(".", [var.kthw_classb_network, "2.10"]),
    join(".", [var.kthw_classb_network, "3.10"])
  ]
  worker_ip = [
    join(".", [var.kthw_classb_network, "1.11"]),
    join(".", [var.kthw_classb_network, "2.11"]),
    join(".", [var.kthw_classb_network, "3.11"])
  ]
  subnet_cidr = [
    join(".", [var.kthw_classb_network, "1.0/24"]),
    join(".", [var.kthw_classb_network, "2.0/24"]),
    join(".", [var.kthw_classb_network, "3.0/24"])
  ]
  vpc_cidr = join(".", [var.kthw_classb_network, "0.0/16"])
}
