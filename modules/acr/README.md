# acr

Azure Container Registry with a private endpoint.

## Secure defaults
- Admin user off, anonymous pull off. Use `AcrPull` / `AcrPush` roles.
- Public network access off.
- Untagged manifests deleted after 7 days.

## Cost note
Disabling public access and private endpoints need the **Premium** SKU (noticeably more per day
than Basic, check the Azure pricing calculator). `sku` is a variable. With `Basic`/`Standard` you
must set `public_network_access_enabled = true` (a validation rule enforces this).

## Usage
```hcl
module "acr" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/acr?ref=v1.0.0"

  name                       = "crkrconnectsdevcin001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  sku                        = "Premium"
  private_endpoint_subnet_id = module.network.subnet_ids["snet-pe-krconnects-dev-cin-001"]
  private_dns_zone_id        = module.network.private_dns_zone_ids["privatelink.azurecr.io"]
}
```

## Outputs
`id`, `name`, `login_server`.
