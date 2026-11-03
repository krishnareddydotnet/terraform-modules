resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type

  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  # No anonymous (public) blob access, even if someone sets a container to public.
  allow_nested_items_to_be_public = false

  # No account keys or SAS tokens: every request must use Entra ID (RBAC).
  # Leaked keys are a top cause of storage breaches. The provider needs storage_use_azuread = true.
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true

  public_network_access             = "Disabled"
  cross_tenant_replication_enabled  = false
  infrastructure_encryption_enabled = true

  blob_properties {
    # Versioning + soft delete protect against accidental delete/overwrite and ransomware.
    versioning_enabled = true

    delete_retention_policy {
      days = var.blob_soft_delete_days
    }

    container_delete_retention_policy {
      days = var.blob_soft_delete_days
    }
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  for_each = toset(var.containers)

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${var.name}-blob"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.name}-blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}
