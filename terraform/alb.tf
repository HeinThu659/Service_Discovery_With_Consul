resource "aws_lb_target_group" "dashboard" {
  name     = "${local.name_prefix}-dashboard-tg"
  port     = var.dashboard_app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.consul-demo.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb" "dashboard" {
  name               = "${local.name_prefix}-dashboard-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.consul-demo-dashboard-alb.id]

  subnets = [
    aws_subnet.consul-demo-public["public_a_alb"].id,
    aws_subnet.consul-demo-public["public_c_alb"].id
  ]
}

resource "aws_lb_listener" "dashboard" {
  load_balancer_arn = aws_lb.dashboard.arn
  port              = var.dashboard_app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard.arn
  }
}


resource "aws_lb_target_group" "counting" {
  name     = "${local.name_prefix}-counting-tg"
  port     = var.counting_app_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.consul-demo.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb" "counting" {
  name               = "${local.name_prefix}-counting-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.consul-demo-counting-alb.id
  ]

  subnets = [
    aws_subnet.consul-demo-private["private_a_counting_alb"].id,
    aws_subnet.consul-demo-private["private_c_counting_alb"].id
  ]
}

resource "aws_lb_listener" "counting" {
  load_balancer_arn = aws_lb.counting.arn
  port              = var.counting_app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting.arn
  }
}
