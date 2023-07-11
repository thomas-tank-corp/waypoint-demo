# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

project = "first-test"

app "go-k8s" {
  labels = {
    "service" = "go-k8s",
    "env"     = "dev"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        # Replace with your docker image name (i.e. registry.hub.docker.com/library/go-k8s)
        image = "test"
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
    }
  }
}


config {
  env = {
    "DATABASE_CONNECTION" = dynamic("terraform-cloud", {
            organization = "tom-se-hashi"
            workspace = "dev-app-clousql"
            output = "postgres_connection_name"
    })
  }
}

variable "cloudsql" {
  default = dynamic("terraform-cloud", {
    organization = "tom-se-hashi"
    workspace    = "dev-app-cloudsql"
    output       = "postgres_connection_name"
  })
  type    = string
  sensitive   = false
  description = "postgres connection"
}

variable "registry_username" {
  type = string
  default = ""
  env = ["REGISTRY_USERNAME"]
}

variable "registry_password" {
  type = string
  sensitive = true
  default = ""
  env = ["REGISTRY_PASSWORD"]
}



