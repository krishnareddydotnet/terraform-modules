variable "name" {
  description = "Web app name (globally unique), for example app-krconnects-dev-cin-001."
  type        = string
}

variable "service_plan_name" {
  description = "App Service plan name, for example asp-krconnects-dev-cin-001."
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

variable "sku_name" {
  description = "Plan SKU. B1 or higher is needed for VNet integration and Always On."
  type        = string
  default     = "B1"
}

variable "dotnet_version" {
  description = ".NET version, for example 8.0 or 10.0 (10.0 = current LTS)."
  type        = string
  default     = "10.0"
}

variable "health_check_path" {
  description = "Path App Service calls to check the app is healthy, for example /health. Unhealthy instances are replaced."
  type        = string
  default     = "/health"
}

variable "vnet_integration_subnet_id" {
  description = "Subnet ID for outbound VNet integration (delegated to Microsoft.Web/serverFarms)."
  type        = string
}

variable "app_settings" {
  description = <<-EOT
    App settings. For secrets use a Key Vault reference, never the value:
    "@Microsoft.KeyVault(SecretUri=https://<vault>.vault.azure.net/secrets/<name>/)"
  EOT
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Allow inbound traffic from the internet (set false when fronted by a private endpoint / gateway)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
