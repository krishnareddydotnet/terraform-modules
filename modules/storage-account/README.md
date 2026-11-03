# storage-account

StorageV2 account with a blob private endpoint.

## Secure defaults
- TLS 1.2, HTTPS only, infrastructure (double) encryption.
- No anonymous blob access. No shared key / SAS: Entra ID only.
- Public network access `Disabled`, network rules default `Deny`.
- Blob versioning + blob and container soft delete (7 days).
- ZRS replication by default.

## Usage
```hcl
module "storage" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/storage-account?ref=v1.0.0"

  name                       = "stkrcdevcin001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  containers                 = ["uploads"]
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-krconnects-dev-cin-001"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.blob.core.windows.net"]
}
```

## Notes
- Shared keys are off, so the caller's provider block needs `storage_use_azuread = true`.
- Access data with roles such as `Storage Blob Data Contributor`.

## Outputs
`id`, `name`, `primary_blob_endpoint`, `blob_service_id`.
