resource "aws_subnet" "public" {
  for_each                = toset(local.azs_to_use)
  availability_zone       = each.value
  cidr_block              = cidrsubnet(cidrsubnet(aws_vpc.main.cidr_block, 1, 0), local.cidr_newbits - 1, index(data.aws_availability_zones.available.names, each.value)) # Subdivides the VPC Cidr block in half, and then subdivides the first half of that VPC into a public subnet per AZ
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id

  tags = {
    Name = "${local.env}-public-${regex("\\w+$", each.value)}"
  }
}

resource "aws_route" "public_internet_ipv4" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env}-igw"
  }
}
