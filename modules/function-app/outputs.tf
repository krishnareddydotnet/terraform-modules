output "id" {
  description = "Function app ID."
  value       = azurerm_linux_function_app.this.id
}

output "name" {
  description = "Function app name."
  value       = azurerm_linux_function_app.this.name
}

output "default_hostname" {
  description = "Default host name."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "principal_id" {
  description = "Principal ID of the function app identity (give it Key Vault Secrets User)."
  value       = azurerm_linux_function_app.this.identity[0].principal_id
}
