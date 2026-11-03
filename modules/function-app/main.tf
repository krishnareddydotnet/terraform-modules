resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  functions_extension_version = "~4"

  # Storage via managed identity: no storage account key in app settings.
  storage_account_name          = var.storage_account_name
  storage_uses_managed_identity = true

  # Legacy dashboard logging needs a storage key. Use Application Insights instead.
  builtin_logging_enabled = false

  https_only                    = true
  public_network_access_enabled = var.public_network_access_enabled

  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  # Outbound through the VNet, so the host can reach storage and Key Vault private endpoints.
  virtual_network_subnet_id = var.vnet_integration_subnet_id

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

    application_stack {
      dotnet_version              = var.dotnet_version
      use_dotnet_isolated_runtime = true
    }
  }

  tags = var.tags
}

# The Functions host stores keys and locks in blobs and uses queues for some triggers.
resource "azurerm_role_assignment" "storage_blob" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_queue" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.this.identity[0].principal_id
}
