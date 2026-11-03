output "id" {
  description = "Registry ID (scope for AcrPull/AcrPush role assignments)."
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Registry name."
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Login server, for example crkrconnectsdevcin001.azurecr.io."
  value       = azurerm_container_registry.this.login_server
}
