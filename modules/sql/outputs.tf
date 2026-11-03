output "server_id" {
  description = "SQL server ID."
  value       = azurerm_mssql_server.this.id
}

output "server_fqdn" {
  description = "SQL server FQDN (resolves to the private IP inside the VNet)."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "Database ID (diagnostic settings target)."
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "Database name."
  value       = azurerm_mssql_database.this.name
}
