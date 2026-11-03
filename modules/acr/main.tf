resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  # Admin user is a shared username/password. Use Entra ID + AcrPull/AcrPush roles instead.
  admin_enabled          = false
  anonymous_pull_enabled = false

  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = "AzureServices"

  # Deletes untagged manifests after 7 days (Premium only). Fewer stale, unpatched images.
  retention_policy_in_days = var.sku == "Premium" ? 7 : null

  tags = var.tags
}

# Private endpoints are a Premium-only feature.
resource "azurerm_private_endpoint" "this" {
  count = var.sku == "Premium" ? 1 : 0

  name                = "pe-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.name}"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}
