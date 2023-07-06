resource "aws_vpc" "main" {
  cidr_block                       = local.cidr_block
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = local.env
  }
}
