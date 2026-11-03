variable "name" {
  description = "Workspace name, for example log-krconnects-dev-cin-001."
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

variable "retention_in_days" {
  description = "Days to keep logs (30-730). Longer retention costs more."
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Daily ingestion cap in GB. Protects against a surprise bill. -1 means no cap."
  type        = number
  default     = 1
}

variable "diagnostic_settings" {
  description = <<-EOT
    Reusable diagnostic settings pattern: resources whose logs and metrics are sent to this workspace.
    Map key = short name (used in the setting name), value = target resource ID.
    The target must support the "allLogs" category group and "AllMetrics" (Key Vault, ACR, AKS,
    App Service, Function App, SQL database, storage blob service, VNet).
  EOT
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
