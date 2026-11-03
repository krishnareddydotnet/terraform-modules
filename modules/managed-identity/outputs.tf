output "id" {
  description = "Identity resource ID."
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Object (principal) ID, used for role assignments."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID, used by apps, Workload Identity and azure/login."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant ID of the identity."
  value       = azurerm_user_assigned_identity.this.tenant_id
}
