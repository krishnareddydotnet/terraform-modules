variable "server_name" {
  description = "SQL server name (globally unique), for example sql-krconnects-dev-cin-001."
  type        = string
}

variable "database_name" {
  description = "Database name, for example sqldb-krconnects-dev-cin-001."
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

variable "database_sku_name" {
  description = "Database SKU, for example Basic, S0, GP_S_Gen5_1 (serverless)."
  type        = string
  default     = "Basic"
}

variable "entra_admin_login" {
  description = "Display name of the Entra ID admin (user or group). Prefer a group."
  type        = string
}

variable "entra_admin_object_id" {
  description = "Object ID of the Entra ID admin (user or group)."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID that receives SQL audit logs."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint."
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of the privatelink.database.windows.net private DNS zone."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
