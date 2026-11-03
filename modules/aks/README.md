# aks

AKS cluster with a system node pool and a user node pool.

## Secure defaults
- Private API server by default (`private_cluster_enabled = true`). For a public API, use `api_server_authorized_ip_ranges`.
- OIDC issuer + Workload Identity (pods use federated credentials, no secrets).
- Entra ID auth + Azure RBAC for Kubernetes, local accounts disabled.
- Azure Policy add-on, Container Insights (managed identity auth), Key Vault CSI driver.
- Encryption at host, Azure Linux nodes, automatic patch upgrades and node image updates.
- Azure CNI Overlay + Cilium network policy.
- System pool runs only critical add-ons; apps run on the user pool.

## Prerequisites
- A user-assigned identity for the control plane (see `managed-identity`). The module gives it `Network Contributor` on the node subnet, so the deployer needs `User Access Administrator` or `Owner`.
- Encryption at host needs a one-time feature registration:
  `az feature register --namespace Microsoft.Compute --name EncryptionAtHost`

## Usage
```hcl
module "aks" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/aks?ref=v1.0.0"

  name                       = "aks-krconnects-dev-cin-001"
  resource_group_name        = "rg-krconnects-dev-cin-001"
  dns_prefix                 = "krconnects-dev"
  identity_id                = module.aks_identity.id
  identity_principal_id      = module.aks_identity.principal_id
  node_subnet_id             = module.network.subnet_ids["snet-aks-krconnects-dev-cin-001"]
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids     = ["00000000-0000-0000-0000-000000000000"]
  log_analytics_workspace_id = module.log_analytics.id
}
```

## Cost note
Defaults are small (1 system + 1 user node, Free tier). For prod use `sku_tier = "Standard"`,
3 system nodes and `zones = ["1", "2", "3"]`.

## Outputs
`id`, `name`, `oidc_issuer_url`, `kubelet_identity_object_id` (give it `AcrPull`), `node_resource_group`.
