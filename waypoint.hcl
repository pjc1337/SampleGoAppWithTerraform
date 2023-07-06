# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "registry_username" {
  type    = string
  default = ""
  env     = ["REGISTRY_USERNAME"]
}

variable "registry_password" {
  type      = string
  sensitive = true
  default   = ""
  env       = ["REGISTRY_PASSWORD"]
}

project = "go-web"

app "go-web" {
  labels = {
    "service" = "go-web",
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        # Replace with your docker image name (i.e. registry.hub.docker.com/library/go-web)
        image = "${var.registry_username}/go-web"
        tag   = gitrefpretty()
        local = true
        auth {
          username = var.registry_username
          password = var.registry_password
        }
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      service_port = 3000
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      // port          = 3000
    }
  }
}
