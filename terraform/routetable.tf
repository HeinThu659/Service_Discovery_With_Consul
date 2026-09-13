resource "aws_route_table" "consul-demo-public" {
  vpc_id = aws_vpc.consul-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.consul-demo.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-route-table"
    }
  )
}

resource "aws_route_table_association" "consul-demo-public" {
  for_each = aws_subnet.consul-demo-public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.consul-demo-public.id
}


resource "aws_route_table" "consul-demo-private" {
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-route-table"
    }
  )
}

resource "aws_route_table_association" "consul-demo-private" {
  for_each = aws_subnet.consul-demo-private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.consul-demo-private.id
}


resource "aws_internet_gateway" "consul-demo" {
  vpc_id = aws_vpc.consul-demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-internet-gateway"
    }
  )
}