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
        image = "go-web"
        tag   = gitrefpretty()
      }
    }
  }

  deploy {
    use "docker" {
      service_port = 80
    }
  }
}

