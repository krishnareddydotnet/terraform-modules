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

variable "admin_group_object_ids" {
  description = "Entra ID group object IDs that get AKS cluster admin."
  type        = list(string)
}

variable "private_cluster_enabled" {
  description = "Private API server. false here so you can run kubectl from your laptop; use true in real environments."
  type        = bool
  default     = false
}

variable "api_server_authorized_ip_ranges" {
  description = "Your public IP in CIDR form, for example [\"203.0.113.10/32\"]. Only these IPs reach the public API server."
  type        = list(string)
}

variable "acr_sku" {
  description = "ACR SKU. Premium is needed for the private endpoint (extra cost)."
  type        = string
  default     = "Premium"
}
