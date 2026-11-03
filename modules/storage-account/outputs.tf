output "id" {
  description = "Storage account ID (scope for role assignments)."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Blob endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "blob_service_id" {
  description = "Blob service ID, use it as the diagnostic settings target."
  value       = "${azurerm_storage_account.this.id}/blobServices/default"
}
