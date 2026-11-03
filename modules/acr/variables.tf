variable "name" {
  description = "Registry name (5-50 letters/numbers, globally unique), for example crkrconnectsdevcin001."
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

variable "public_network_access_enabled" {
  description = "Allow pulls/pushes from public networks. Keep false (needs Premium SKU)."
  type        = bool
  default     = false
}

variable "sku" {
  description = "Basic, Standard or Premium. Premium is required for private endpoints and disabling public access (higher cost)."
  type        = string
  default     = "Premium"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be Basic, Standard or Premium."
  }

  validation {
    condition     = var.sku == "Premium" || var.public_network_access_enabled
    error_message = "Only the Premium SKU can disable public network access. Use Premium or set public_network_access_enabled = true."
  }
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint (used only with Premium SKU)."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "ID of the privatelink.azurecr.io private DNS zone (used only with Premium SKU)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
