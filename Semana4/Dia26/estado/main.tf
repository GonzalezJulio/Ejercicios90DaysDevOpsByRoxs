terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "app_config" {
  filename = "app-${terraform.workspace}.conf"
  content = <<-EOF
    [Application]
    environment = ${terraform.workspace}
    debug = ${terraform.workspace == "dev" ? "true" : "false"}
    port = ${terraform.workspace == "dev" ? "8080" : "80"}
  EOF
}
