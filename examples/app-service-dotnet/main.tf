data "azurerm_client_config" "current" {}

locals {
  suffix = "${var.project}-${var.environment}-cin-001"

  tags = {
    environment   = var.environment
    owner         = var.owner
    project       = var.project
    "cost-center" = var.cost_center
    "managed-by"  = "terraform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.suffix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name                = "vnet-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  address_space       = ["10.20.0.0/16"]

  subnets = {
    # App Service VNet integration needs a subnet delegated to Microsoft.Web/serverFarms.
    "snet-app-${local.suffix}" = {
      address_prefixes = ["10.20.1.0/24"]
      delegation       = "Microsoft.Web/serverFarms"
    }
    "snet-pe-${local.suffix}" = {
      address_prefixes = ["10.20.2.0/24"]
    }
  }

  private_dns_zone_names = ["privatelink.vaultcore.azure.net"]
  tags                   = local.tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name                       = "kv-${local.suffix}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-${local.suffix}"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.vaultcore.azure.net"]
  tags                       = local.tags
}

module "app_service" {
  source = "../../modules/app-service"

  name                       = "app-${local.suffix}"
  service_plan_name          = "asp-${local.suffix}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = var.location
  dotnet_version             = var.dotnet_version
  vnet_integration_subnet_id = module.network.subnet_ids["snet-app-${local.suffix}"]

  # Key Vault reference: the app reads the secret at runtime with its managed identity.
  # The secret value never appears in Terraform code or state.
  app_settings = {
    "DemoSecret" = "@Microsoft.KeyVault(VaultName=kv-${local.suffix};SecretName=demo-secret)"
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "app_kv_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service.principal_id
}

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "log-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  diagnostic_settings = {
    "kv"  = module.key_vault.id
    "app" = module.app_service.id
  }

  tags = local.tags
}
