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
  address_space       = ["10.30.0.0/16"]

  subnets = {
    # With CNI Overlay, pods get IPs from pod_cidr, so the node subnet can stay small.
    "snet-aks-${local.suffix}" = {
      address_prefixes = ["10.30.0.0/24"]
    }
    "snet-pe-${local.suffix}" = {
      address_prefixes = ["10.30.1.0/24"]
    }
  }

  private_dns_zone_names = ["privatelink.azurecr.io"]
  tags                   = local.tags
}

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "log-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  diagnostic_settings = {
    "acr" = module.acr.id
  }

  tags = local.tags
}

module "acr" {
  source = "../../modules/acr"

  # ACR names allow only letters and numbers.
  name                       = "cr${replace(local.suffix, "-", "")}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = var.location
  sku                        = var.acr_sku
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-${local.suffix}"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.azurecr.io"]
  tags                       = local.tags
}

# Control-plane identity of the cluster.
module "aks_identity" {
  source = "../../modules/managed-identity"

  name                = "id-aks-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  tags                = local.tags
}

module "aks" {
  source = "../../modules/aks"

  name                            = "aks-${local.suffix}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  dns_prefix                      = "${var.project}-${var.environment}"
  private_cluster_enabled         = var.private_cluster_enabled
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  identity_id                     = module.aks_identity.id
  identity_principal_id           = module.aks_identity.principal_id
  node_subnet_id                  = module.network.subnet_ids["snet-aks-${local.suffix}"]
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids          = var.admin_group_object_ids
  log_analytics_workspace_id      = module.log_analytics.id
  tags                            = local.tags
}

# Nodes pull images with their kubelet identity. No imagePullSecrets needed.
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

# Workload Identity for an app: pods using service account "demo/workload-sa"
# can get Entra ID tokens as this identity.
module "workload_identity" {
  source = "../../modules/managed-identity"

  name                = "id-workload-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  federated_credentials = {
    "fc-aks-demo-workload-sa" = {
      issuer  = module.aks.oidc_issuer_url
      subject = "system:serviceaccount:demo:workload-sa"
    }
  }

  tags = local.tags
}
