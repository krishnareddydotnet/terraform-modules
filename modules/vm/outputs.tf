output "id" {
  description = "VM ID."
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "VM name."
  value       = azurerm_linux_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Private IP address of the VM."
  value       = azurerm_network_interface.this.private_ip_address
}

output "principal_id" {
  description = "Principal ID of the VM managed identity (for role assignments)."
  value       = azurerm_linux_virtual_machine.this.identity[0].principal_id
}
