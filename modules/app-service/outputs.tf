output "id" {
  description = "Web app ID."
  value       = azurerm_linux_web_app.this.id
}

output "name" {
  description = "Web app name."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Default host name, for example app-krconnects-dev-cin-001.azurewebsites.net."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  description = "Principal ID of the web app identity (give it Key Vault Secrets User)."
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

output "service_plan_id" {
  description = "App Service plan ID."
  value       = azurerm_service_plan.this.id
}
