output "id" {
  description = "Key Vault ID (scope for role assignments)."
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "Key Vault URI, used in Key Vault references."
  value       = azurerm_key_vault.this.vault_uri
}

output "private_endpoint_ip" {
  description = "Private IP address of the private endpoint."
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
