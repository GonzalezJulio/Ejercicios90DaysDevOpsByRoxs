output "app_info" {
  description = "Información de la aplicación desplegada"
  value = {
    environment   = terraform.workspace
    app_url       = "http://localhost:${local.current_config.external_port}"
    replica_count = local.current_config.replica_count
    memory_per_container = "${local.current_config.memory_mb}MB"
    container_names = docker_container.app[*].name
    network_name = docker_network.app_network.name
  }
}
