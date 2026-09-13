resource "aws_vpc" "consul-demo" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-vpc-${var.aws_region}"

  })

}

resource "aws_vpc_endpoint" "consul-demo-s3" {

  vpc_id = aws_vpc.consul-demo.id

  service_name = "com.amazonaws.${var.aws_region}.s3"

  vpc_endpoint_type = "Gateway"

  route_table_ids = [

    aws_route_table.consul-demo-public.id,

    aws_route_table.consul-demo-private.id

  ]

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-s3-endpoint"

  })

}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.consul-demo.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.consul-demo-private["private_a_dashboard"].id,
    aws_subnet.consul-demo-private["private_c_dashboard"].id
  ]

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssm-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.consul-demo.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.consul-demo-private["private_a_dashboard"].id,
    aws_subnet.consul-demo-private["private_c_dashboard"].id
  ]

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssmmessages-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.consul-demo.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.consul-demo-private["private_a_dashboard"].id,
    aws_subnet.consul-demo-private["private_c_dashboard"].id
  ]

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2messages-endpoint"
    }
  )
}