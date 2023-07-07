# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "registry_username" {
  type    = string
  default = "parkerclelland"
  env     = ["REGISTRY_USERNAME"]
}

variable "registry_password" {
  type      = string
  sensitive = true
  default   = "dckr_pat_m94m0_WGmv_k1qHeGMEQMN9LsYw"
  env       = ["REGISTRY_PASSWORD"]
}

project = "SampleGoAppWithTerraform"

runner {
  enabled = true
  data_source "git" {
    url = "https://github.com/pjc1337/SampleGoAppWithTerraform.git"
    ref = "HEAD"
  }
  poll {
    enabled = true
  }
}



app "go-web" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "${var.registry_username}/go-web"
        tag   = "latest" #gitrefpretty()
        auth {
          username = var.registry_username
          password = var.registry_password
        }
      }
    }
  }

  deploy {
    use "docker" {
      service_port = 80
    }
  }
}

