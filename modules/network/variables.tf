variable "name" {
  description = "Virtual network name, for example vnet-krconnects-dev-cin-001."
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

variable "address_space" {
  description = "Address space of the virtual network, for example [\"10.10.0.0/16\"]."
  type        = list(string)
}

variable "subnets" {
  description = <<-EOT
    Subnets to create. The map key is the subnet name.
    - address_prefixes: subnet ranges.
    - nsg_enabled: create and attach an NSG (set false for AzureBastionSubnet, which needs its own special rules).
    - delegation: service to delegate the subnet to, for example "Microsoft.Web/serverFarms" for App Service VNet integration.
  EOT
  type = map(object({
    address_prefixes = list(string)
    nsg_enabled      = optional(bool, true)
    delegation       = optional(string)
  }))
}

variable "private_dns_zone_names" {
  description = "Private DNS zones to create and link to this VNet, for example [\"privatelink.vaultcore.azure.net\"]."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
