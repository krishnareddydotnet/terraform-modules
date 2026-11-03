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

variable "dotnet_version" {
  description = ".NET version of the web app."
  type        = string
  default     = "10.0"
}
