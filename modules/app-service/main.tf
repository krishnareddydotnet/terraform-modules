resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  https_only                    = true
  public_network_access_enabled = var.public_network_access_enabled
  client_affinity_enabled       = false

  # Basic-auth publishing (FTP and WebDeploy user/password) off. Deploy with Entra ID (az / GitHub OIDC).
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  # Outbound traffic goes through the VNet, so the app can reach private endpoints (Key Vault, SQL).
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  # The system identity is used to resolve Key Vault references in app_settings.
  identity {
    type = "SystemAssigned"
  }

  app_settings = var.app_settings

  site_config {
    always_on               = true
    ftps_state              = "Disabled"
    http2_enabled           = true
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
    vnet_route_all_enabled  = true

    health_check_path                 = var.health_check_path
    health_check_eviction_time_in_min = 10

    application_stack {
      dotnet_version = var.dotnet_version
    }
  }

  tags = var.tags
}
