resource "aws_subnet" "private" {
  for_each          = toset(local.azs_to_use)
  availability_zone = each.value
  cidr_block        = cidrsubnet(cidrsubnet(aws_vpc.main.cidr_block, 1, 1), local.cidr_newbits - 1, index(data.aws_availability_zones.available.names, each.value)) # Subdivides the VPC Cidr block in half, and then subdivides the second half of that VPC into a private subnet per AZ
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${local.env}-private-${regex("\\w+$", each.value)}"
  }
}

resource "aws_eip" "ngw" {
  for_each = local.solo_nat_gateway ? toset([local.azs_to_use[0]]) : toset(local.azs_to_use)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  for_each      = local.solo_nat_gateway ? toset([local.azs_to_use[0]]) : toset(local.azs_to_use)
  allocation_id = aws_eip.ngw[each.value].id
  subnet_id     = aws_subnet.public[each.value].id

  tags = {
    Name = local.solo_nat_gateway ? "${local.env}-nat-gateway" : "${local.env}-nat-gateway-${regex("$\\w+", each.value)}"
  }
}

resource "aws_route_table" "private" {
  for_each = local.solo_nat_gateway ? toset([local.azs_to_use[0]]) : toset(local.azs_to_use)
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = local.env
  }
}

resource "aws_route_table_association" "private" {
  for_each       = local.solo_nat_gateway ? toset([local.azs_to_use[0]]) : toset(local.azs_to_use)
  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

resource "aws_route" "private_ipv4" {
  for_each               = local.solo_nat_gateway ? toset([local.azs_to_use[0]]) : toset(local.azs_to_use)
  route_table_id         = aws_route_table.private[each.value].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[each.value].id
}
