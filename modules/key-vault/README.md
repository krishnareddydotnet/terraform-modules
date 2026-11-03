# key-vault

Key Vault with a private endpoint.

## Secure defaults
- RBAC authorization (no access policies).
- Soft delete + purge protection (default 90 days).
- Public network access off, network ACL default `Deny`.
- Private endpoint registered in `privatelink.vaultcore.azure.net`.

## Usage
```hcl
module "key_vault" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/key-vault?ref=v1.0.0"

  name                       = "kv-krc-dev-cin-001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-krconnects-dev-cin-001"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.vaultcore.azure.net"]
}
```

## Notes
- Grant access with roles, for example `Key Vault Secrets User` (read) or `Key Vault Secrets Officer` (write).
- Public access is off, so add secrets from inside the VNet (VM, pipeline agent) or briefly allow your IP.
- With purge protection a deleted vault name is blocked until the retention period ends.

## Outputs
`id`, `name`, `vault_uri`, `private_endpoint_ip`.
