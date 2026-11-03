# function-app

Linux App Service plan + .NET isolated Function App.

## Secure defaults
- Host storage via managed identity (`storage_uses_managed_identity = true`), no storage key.
  The module grants `Storage Blob Data Owner` and `Storage Queue Data Contributor` on the account.
- HTTPS only, TLS 1.2, FTP off, basic-auth publishing off, legacy key-based logging off.
- System-assigned identity for Key Vault references.
- Outbound VNet integration with route-all.

## Usage
```hcl
module "function_app" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/function-app?ref=v1.0.0"

  name                       = "func-krconnects-dev-cin-001"
  service_plan_name          = "asp-func-krconnects-dev-cin-001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  storage_account_id         = module.storage.id
  storage_account_name       = module.storage.name
  vnet_integration_subnet_id = module.network.subnet_ids["snet-func-krconnects-dev-cin-001"]
}
```

## Notes
- Uses a dedicated plan (B1 default). Consumption (Y1) does not support VNet integration.
- If the storage account is private, the function needs private endpoints (and DNS zones) for each
  storage service it uses: `blob` always, plus `queue` / `table` for those triggers.

## Outputs
`id`, `name`, `default_hostname`, `principal_id`.
