output "vnet_id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet name to subnet ID."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

output "nsg_ids" {
  description = "Map of subnet name to NSG ID."
  value       = { for name, nsg in azurerm_network_security_group.this : name => nsg.id }
}

output "private_dns_zone_ids" {
  description = "Map of private DNS zone name to zone ID."
  value       = { for name, zone in azurerm_private_dns_zone.this : name => zone.id }
}
