output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "web_app_name" {
  description = "Web app name."
  value       = module.app_service.name
}

output "web_app_url" {
  description = "Web app URL."
  value       = "https://${module.app_service.default_hostname}"
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.key_vault.name
}
