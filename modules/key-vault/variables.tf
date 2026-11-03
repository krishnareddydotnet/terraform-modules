variable "name" {
  description = "Key Vault name (3-24 chars, globally unique), for example kv-krc-dev-cin-001."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "tenant_id" {
  description = "Entra ID tenant ID that the vault trusts."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU: standard or premium (premium = HSM-backed keys)."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Days a deleted vault or secret can be recovered (7-90)."
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Block permanent delete during the retention period. Protects against ransomware or accidental purge. Cannot be turned off once enabled."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Allow access from public networks. Keep false and use the private endpoint."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint."
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of the privatelink.vaultcore.azure.net private DNS zone."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
