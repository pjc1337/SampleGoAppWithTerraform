variable "region" {
  default = {
    prod = "us-east-2"
  }
}

variable "default_region" {
  default = "us-east-1"
}

variable "env" {
  default = ""
}

variable "web_server_count" {
  default = {
    prod = 3
  }
}

variable "default_web_server_count" {
  default = 1
}