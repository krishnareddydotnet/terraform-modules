# managed-identity

User-assigned managed identity, plus optional federated credentials (no secrets).

## Secure defaults
- No client secret ever exists. Trust is based on a signed OIDC token from the issuer.
- Audience is fixed to `api://AzureADTokenExchange`.

## Usage
```hcl
module "workload_identity" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/managed-identity?ref=v1.0.0"

  name                = "id-orders-dev-cin-001"
  resource_group_name = "rg-krconnects-dev-cin-001"

  federated_credentials = {
    # AKS Workload Identity
    "fc-aks-orders" = {
      issuer  = module.aks.oidc_issuer_url
      subject = "system:serviceaccount:orders:orders-sa"
    }
    # GitHub Actions OIDC (environment-scoped)
    "fc-github-dev" = {
      issuer  = "https://token.actions.githubusercontent.com"
      subject = "repo:krishnareddydotnet/krconnects-infra:environment:dev"
    }
  }
}
```

## Outputs
`id`, `principal_id` (for role assignments), `client_id` (for apps / azure/login), `tenant_id`.
