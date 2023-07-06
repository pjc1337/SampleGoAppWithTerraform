locals {
  env                            = coalesce(var.env, terraform.workspace)
  region                         = lookup(var.region, local.env, var.default_region)
  azs_to_use                     = slice(data.aws_availability_zones.available.names, 0, local.num_of_azs)
  cidr_block                     = lookup(var.cidr_block, local.env)
  max_subnet_cidr_mask           = 28 // in AWS, the minimum size of a subnet is a /28
  num_of_subnet_categories       = 2  // public and private subnets
  num_of_azs                     = lookup(var.num_of_azs, local.env, var.default_num_of_azs)
  solo_nat_gateway               = lookup(var.solo_nat_gateway, local.env, true)
  vpc_cidr_subnet_mask           = regex("\\d*$", local.cidr_block)
  num_of_ips                     = pow(2, 32 - local.vpc_cidr_subnet_mask)
  num_of_ips_per_az              = local.num_of_ips / local.num_of_azs
  cidr_newbits                   = local.num_of_ips_per_az >= local.min_num_of_ips ? 32 - ceil(log(local.num_of_ips_per_az / local.num_of_subnet_categories, 2)) - local.vpc_cidr_subnet_mask : local.max_subnet_cidr_mask - local.vpc_cidr_subnet_mask
  subnet_ips                     = pow(2, local.max_subnet_cidr_mask - local.vpc_cidr_subnet_mask - local.cidr_newbits)
  max_num_of_subnets_in_vpc_cidr = local.num_of_ips / local.subnet_ips
  min_num_of_ips                 = pow(2, 32 - local.max_subnet_cidr_mask)
}
