resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = var.federated_credentials

  name                      = each.key
  user_assigned_identity_id = azurerm_user_assigned_identity.this.id
  issuer                    = each.value.issuer
  subject                   = each.value.subject
  # Standard audience for Entra ID token exchange (same value for AKS and GitHub).
  audience = ["api://AzureADTokenExchange"]
}
