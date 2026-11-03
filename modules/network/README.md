# network

VNet, subnets, one NSG per subnet, and private DNS zones linked to the VNet.

## Secure defaults
- Every subnet gets an NSG with an explicit `deny-internet-inbound` rule (deny by default).
- `default_outbound_access_enabled = false`: no hidden internet outbound.
- Private DNS zones (for private endpoints) are an input, so each env decides which ones it needs.

## Usage
```hcl
module "network" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/network?ref=v1.0.0"

  name                = "vnet-krconnects-dev-cin-001"
  resource_group_name = "rg-krconnects-dev-cin-001"
  address_space       = ["10.10.0.0/16"]

  subnets = {
    "snet-app-krconnects-dev-cin-001" = { address_prefixes = ["10.10.1.0/24"], delegation = "Microsoft.Web/serverFarms" }
    "snet-pe-krconnects-dev-cin-001"  = { address_prefixes = ["10.10.2.0/24"] }
  }

  private_dns_zone_names = ["privatelink.vaultcore.azure.net"]
  tags                   = local.tags
}
```

## Notes
- Need an allow rule? Add an `azurerm_network_security_rule` with priority < 4096 using the `nsg_ids` output.
- `AzureBastionSubnet`: set `nsg_enabled = false` (Bastion needs its own special NSG rules).

## Outputs
`vnet_id`, `vnet_name`, `subnet_ids`, `nsg_ids`, `private_dns_zone_ids` (maps keyed by name).
