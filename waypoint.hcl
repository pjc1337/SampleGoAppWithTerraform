project = "SampleGoAppWithTerraform"

runner {
  enabled = true
  data_source "git" {
    url = "https://github.com/pjc1337/SampleGoAppWithTerraform.git"
    ref = "HEAD"
  }
  poll {
    enabled  = true
    interval = "240s"
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
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "${var.registry_username}/go-web"
        tag   = "latest" #substr(gitrefpretty(), 0, 12)
        auth {
          hostname = "registry.hub.docker.com"
          username = var.registry_username
          password = var.registry_password
        }
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

