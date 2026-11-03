output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "vm_name" {
  description = "VM name."
  value       = module.vm.name
}

output "vm_private_ip" {
  description = "VM private IP."
  value       = module.vm.private_ip_address
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.key_vault.name
}
