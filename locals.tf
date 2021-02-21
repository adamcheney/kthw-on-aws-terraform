locals {
  availability_zone = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
  subnet_id = [
    aws_subnet.nodes_a.id,
    aws_subnet.nodes_b.id,
    aws_subnet.nodes_c.id
  ]
  control_ip = [
    join(".", [var.kthw_classb_network, "1.0"]),
    join(".", [var.kthw_classb_network, "2.0"]),
    join(".", [var.kthw_classb_network, "3.0"])
  ]
  worker_ip = [
    join(".", [var.kthw_classb_network, "1.1"]),
    join(".", [var.kthw_classb_network, "2.1"]),
    join(".", [var.kthw_classb_network, "3.1"])
  ]
  subnet_cidr = [
    join(".", [var.kthw_classb_network, "1.0/24"]),
    join(".", [var.kthw_classb_network, "2.0/24"]),
    join(".", [var.kthw_classb_network, "3.0/24"])
  ]
  availability_zone = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
  vpc_cidr = join(".", [var.kthw_classb_network, "0.0/16"])
}
