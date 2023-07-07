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

app "go-web" {
  use "docker" {}
  registry {
    use "docker" {
      image = "${var.registry_username}/go-web"
      tag   = "latest"
      auth {
        hostname = "registry.hub.docker.com"
        username = var.registry_username
        password = var.registry_password
      }
    }
  }

  deploy {
    use "docker" {
      service_port = 80
      auth {
        hostname = "registry.hub.docker.com"
        username = var.registry_username
        password = var.registry_password
      }
    }
  }
}

