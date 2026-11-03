variable "name" {
  description = "VM name, for example vm-krconnects-dev-cin-001."
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

variable "size" {
  description = "VM size."
  type        = string
  default     = "Standard_B2s_v2"
}

variable "subnet_id" {
  description = "Subnet ID for the VM network interface."
  type        = string
}

variable "admin_username" {
  description = "Admin user name."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key (contents of id_rsa.pub / id_ed25519.pub). A public key is not a secret."
  type        = string
}

variable "encryption_at_host_enabled" {
  description = "Encrypt temp disk and caches on the host. Needs the EncryptionAtHost feature registered on the subscription."
  type        = bool
  default     = true
}

variable "os_disk_type" {
  description = "OS disk type: Standard_LRS, StandardSSD_LRS, Premium_LRS."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "bastion_enabled" {
  description = "Create an Azure Bastion host for browser SSH. PREMIUM COST (billed per hour even when idle). Default off."
  type        = bool
  default     = false
}

variable "bastion_subnet_id" {
  description = "ID of the subnet named AzureBastionSubnet (/26 or larger). Required when bastion_enabled = true."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
