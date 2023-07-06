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

project = "SampleGoAppWithTerraform"

app "go-web" {
  labels = {
    "service" = "go-web",
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "registry.hub.docker.com/${var.registry_username}/go-web"
        tag   = gitrefpretty()
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
