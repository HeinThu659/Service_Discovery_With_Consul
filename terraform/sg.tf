resource "aws_security_group" "consul-demo-dashboard" {
  name   = "${local.name_prefix}-dashboard-security-group"
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-dashboard-security-group"

  })
}

resource "aws_security_group" "consul-demo-counting" {
  name   = "${local.name_prefix}-counting-security-group"
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-counting-security-group"

  })
}

resource "aws_security_group" "consul-demo-dashboard-alb" {
  name   = "${local.name_prefix}-dashboard-alb-security-group"
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-dashboard-alb-security-group"

  })
}

resource "aws_security_group" "consul-demo-counting-alb" {
  name   = "${local.name_prefix}-counting-alb-security-group"
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-counting-alb-security-group"

  })
}

resource "aws_security_group" "ssm_endpoint" {
  name   = "${local.name_prefix}-ssm-endpoint-security-group"
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssm-endpoint-security-group"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "dashboard-alb" {
  security_group_id = aws_security_group.consul-demo-dashboard-alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8888
  to_port     = 8888
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "dashboard-alb-to-dashboard" {
  security_group_id = aws_security_group.consul-demo-dashboard-alb.id

  referenced_security_group_id = aws_security_group.consul-demo-dashboard.id

  from_port   = 8888
  to_port     = 8888
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "dashboard_alb_to_dashboard_app" {
  security_group_id = aws_security_group.consul-demo-dashboard.id

  referenced_security_group_id = aws_security_group.consul-demo-dashboard-alb.id

  from_port   = 8888
  to_port     = 8888
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "dashboard-to-counting-alb" {
  security_group_id = aws_security_group.consul-demo-dashboard.id

  referenced_security_group_id = aws_security_group.consul-demo-counting-alb.id

  from_port   = 7777
  to_port     = 7777
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "dashboard-to-s3" {
  security_group_id = aws_security_group.consul-demo-dashboard.id
  prefix_list_id    = data.aws_prefix_list.s3.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "counting-alb" {
  security_group_id = aws_security_group.consul-demo-counting-alb.id

  referenced_security_group_id = aws_security_group.consul-demo-dashboard.id
  from_port                    = 7777
  to_port                      = 7777
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "counting-alb-to-counting-app" {
  security_group_id = aws_security_group.consul-demo-counting-alb.id

  referenced_security_group_id = aws_security_group.consul-demo-counting.id

  from_port   = 7777
  to_port     = 7777
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "counting-app" {
  security_group_id = aws_security_group.consul-demo-counting.id

  referenced_security_group_id = aws_security_group.consul-demo-counting-alb.id

  from_port   = 7777
  to_port     = 7777
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "counting-to-s3" {
  security_group_id = aws_security_group.consul-demo-counting.id

  prefix_list_id = data.aws_prefix_list.s3.id
  from_port      = 443
  to_port        = 443
  ip_protocol    = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssm_from_dashboard" {
  security_group_id = aws_security_group.ssm_endpoint.id

  referenced_security_group_id = aws_security_group.consul-demo-dashboard.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssm_from_counting" {
  security_group_id = aws_security_group.ssm_endpoint.id

  referenced_security_group_id = aws_security_group.consul-demo-counting.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "dashboard_to_ssm" {
  security_group_id = aws_security_group.consul-demo-dashboard.id

  referenced_security_group_id = aws_security_group.ssm_endpoint.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "counting_to_ssm" {
  security_group_id = aws_security_group.consul-demo-counting.id

  referenced_security_group_id = aws_security_group.ssm_endpoint.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}