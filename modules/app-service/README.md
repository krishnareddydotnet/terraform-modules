# app-service

Linux App Service plan + .NET web app.

## Secure defaults
- HTTPS only, TLS 1.2 (site and SCM), FTP/FTPS off, basic-auth publishing off.
- System-assigned managed identity, used for Key Vault references.
- Outbound VNet integration with route-all, so the app reaches private endpoints.
- Health check on `/health`.

## Usage
```hcl
module "app_service" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/app-service?ref=v1.0.0"

  name                       = "app-krconnects-dev-cin-001"
  service_plan_name          = "asp-krconnects-dev-cin-001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  vnet_integration_subnet_id = module.network.subnet_ids["snet-app-krconnects-dev-cin-001"]

  app_settings = {
    "ConnectionStrings__Db" = "@Microsoft.KeyVault(VaultName=kv-krc-dev-cin-001;SecretName=db-connection)"
  }
}
```

## Notes
- Give `principal_id` the `Key Vault Secrets User` role on the vault.
- The integration subnet must be delegated to `Microsoft.Web/serverFarms`. Plan SKU must be B1 or higher.

## Outputs
`id`, `name`, `default_hostname`, `principal_id`, `service_plan_id`.
