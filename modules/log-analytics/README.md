# log-analytics

Log Analytics workspace + a reusable diagnostic settings pattern.

## Secure defaults
- `local_authentication_enabled = false`: Entra ID only, no shared workspace keys.
- Daily cap (`daily_quota_gb = 1`) protects against a surprise bill. Retention 30 days.

## Diagnostic settings pattern
Pass a map of `short-name = resource ID`. Each target gets one setting with `allLogs` + `AllMetrics`.
```hcl
module "log_analytics" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/log-analytics?ref=v1.0.0"

  name                = "log-krconnects-dev-cin-001"
  resource_group_name = "rg-krconnects-dev-cin-001"

  diagnostic_settings = {
    "kv"  = module.key_vault.id
    "acr" = module.acr.id
    "st"  = module.storage.blob_service_id
  }
}
```
The map keys are static, so it works even when the IDs are only known after apply.
Targets must support `allLogs` and `AllMetrics` (for storage, use the blob service ID).

## Outputs
`id` (resource ID), `name`, `workspace_id` (customer ID).
