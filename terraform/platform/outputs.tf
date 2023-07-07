output "public_subnets" {
  value = [for az in local.azs_to_use : aws_subnet.public[az].id]
}

output "private_subnets" {
  value = [for az in local.azs_to_use : aws_subnet.private[az].id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}
