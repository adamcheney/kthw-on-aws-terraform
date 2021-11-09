resource "aws_lb" "kthw" {
    name = "kthw"
    load_balancer_type = "network"
    subnets = local.subnet_id
}

resource "aws_lb_target_group" "kthw" {
    target_type = "ip"
    vpc_id = aws_vpc.kthw.id
    protocol = "TCP"
    port = "6443"
}

resource "aws_lb_target_group_attachment" "kthw" {
    count = 3
    target_group_arn = aws_lb_target_group.kthw.arn
    target_id = element(local.worker_ip, count.index)
}

resource "aws_lb_listener" "kthw" {
    load_balancer_arn = aws_lb.kthw.arn
    protocol = "TCP"
    port = "443"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.kthw.arn
    }
}
