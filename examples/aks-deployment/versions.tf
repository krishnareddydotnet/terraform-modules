terraform {
  required_version = ">= 1.17.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.12"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  # Use Entra ID (not account keys) for storage data-plane calls,
  # because the storage module disables shared keys.
  storage_use_azuread = true
}
