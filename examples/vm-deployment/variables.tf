variable "subscription_id" {
  description = "Azure subscription ID to deploy into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "project" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name: dev, test or prod."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag value (team or email)."
  type        = string
}

variable "cost_center" {
  description = "Cost center tag value."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the VM admin user (contents of ~/.ssh/id_ed25519.pub)."
  type        = string
}

variable "bastion_enabled" {
  description = "Create Azure Bastion. PREMIUM COST, keep false unless you need browser SSH."
  type        = bool
  default     = false
}
