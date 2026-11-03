data "azurerm_client_config" "current" {}

locals {
  # CAF naming: <type>-<project>-<env>-<region>-<instance>, for example rg-tfmodvm-dev-cin-001
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
  address_space       = ["10.10.0.0/16"]

  subnets = {
    "snet-vm-${local.suffix}" = {
      address_prefixes = ["10.10.1.0/24"]
    }
    "snet-pe-${local.suffix}" = {
      address_prefixes = ["10.10.2.0/24"]
    }
    # Name is fixed by Azure. Bastion needs its own NSG rules, so no module NSG here.
    "AzureBastionSubnet" = {
      address_prefixes = ["10.10.3.0/26"]
      nsg_enabled      = false
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

module "vm" {
  source = "../../modules/vm"

  name                 = "vm-${local.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  location             = var.location
  subnet_id            = module.network.subnet_ids["snet-vm-${local.suffix}"]
  admin_ssh_public_key = var.admin_ssh_public_key
  bastion_enabled      = var.bastion_enabled
  bastion_subnet_id    = module.network.subnet_ids["AzureBastionSubnet"]
  tags                 = local.tags
}

# Least privilege: the VM can read secrets, nothing else.
resource "azurerm_role_assignment" "vm_kv_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.vm.principal_id
}
