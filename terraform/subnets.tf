resource "aws_subnet" "consul-demo-public" {
  for_each          = var.public_subnet_prefix
  vpc_id            = aws_vpc.consul-demo.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-subnet"
    }
  )

}

resource "aws_subnet" "consul-demo-private" {
  for_each = var.private_subnet_prefix

  vpc_id            = aws_vpc.consul-demo.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-${each.value.type}-subnet"
    }
  )
}