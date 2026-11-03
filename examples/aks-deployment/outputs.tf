output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "aks_name" {
  description = "AKS cluster name."
  value       = module.aks.name
}

output "acr_login_server" {
  description = "ACR login server."
  value       = module.acr.login_server
}

output "workload_identity_client_id" {
  description = "Client ID to put in the service account annotation azure.workload.identity/client-id."
  value       = module.workload_identity.client_id
}
