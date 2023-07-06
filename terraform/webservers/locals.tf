locals {
  env              = coalesce(var.env, terraform.workspace)
  region           = lookup(var.region, terraform.workspace, var.default_region)
  web_server_count = lookup(var.web_server_count, local.env, var.default_web_server_count)
}