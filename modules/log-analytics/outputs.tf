output "id" {
  description = "Workspace resource ID (used by AKS, SQL auditing and diagnostic settings)."
  value       = azurerm_log_analytics_workspace.this.id
}

output "name" {
  description = "Workspace name."
  value       = azurerm_log_analytics_workspace.this.name
}

output "workspace_id" {
  description = "Workspace (customer) ID, used in KQL tools and agents."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}
