# sql

Azure SQL server + one database, with a private endpoint and auditing.

## Secure defaults
- Entra ID-only authentication (no SQL logins, no passwords).
- Public network access off, TLS 1.2.
- TDE on (service-managed key). Express vulnerability assessment on.
- Auditing sent to Log Analytics (diagnostic setting on `master` + auditing policy).

## Usage
```hcl
module "sql" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/sql?ref=v1.0.0"

  server_name                = "sql-krconnects-dev-cin-001"
  database_name              = "sqldb-krconnects-dev-cin-001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  entra_admin_login          = "sg-sql-admins"
  entra_admin_object_id      = "00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = module.log_analytics.id
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-krconnects-dev-cin-001"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.database.windows.net"]
}
```

## Notes
- Use an Entra group as admin, not a person.
- Apps connect with their managed identity (`Authentication=Active Directory Default`).

## Outputs
`server_id`, `server_fqdn`, `database_id`, `database_name`.
