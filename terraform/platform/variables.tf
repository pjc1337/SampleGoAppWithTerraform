variable "cidr_block" {
  default = {
    dev     = "10.2.0.0/16"
    staging = "10.3.0.0/16"
    prod    = "10.4.0.0./16"
  }
}

variable "region" {
  default = {
    produs = "us-east-2"
  }
}

variable "default_region" {
  default = "us-east-1"
}

variable "num_of_azs" {
  default = {
    prod = 4
  }
}

variable "default_num_of_azs" {
  default = 2
}

variable "env" {
  default = ""
}

variable "solo_nat_gateway" {
  default = {
    prod = false
  }
}