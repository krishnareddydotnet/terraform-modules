resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  # Secure default: no implicit internet outbound. Outbound must be explicit
  # (NAT gateway, load balancer, firewall). Azure is retiring default outbound access.
  default_outbound_access_enabled = false

  # Only some subnets need a delegation, so this block is added only when one is set.
  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]

    content {
      name = "delegation"

      service_delegation {
        name = delegation.value
      }
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each = { for name, subnet in var.subnets : name => subnet if subnet.nsg_enabled }

  name                = "nsg-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  # Deny-by-default: Azure's built-in rules already block Internet inbound, but an
  # explicit rule documents the intent and shows up in audits. Add allow rules
  # with a lower priority number (for example 100) using azurerm_network_security_rule.
  security_rule {
    name                       = "deny-internet-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = azurerm_network_security_group.this

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.id
}

resource "azurerm_private_dns_zone" "this" {
  for_each = toset(var.private_dns_zone_names)

  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Without this link, resources in the VNet cannot resolve private endpoint names.
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = azurerm_private_dns_zone.this

  name                 = "link-${var.name}"
  private_dns_zone_id  = each.value.id
  virtual_network_id   = azurerm_virtual_network.this.id
  registration_enabled = false
  tags                 = var.tags
}
