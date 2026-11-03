# terraform-modules

Reusable, secure-by-default Terraform modules for Azure (azurerm 5.x, Terraform 1.17+).
Consumed by [krconnects-infra](https://github.com/krishnareddydotnet/krconnects-infra).

## Folder structure
```
modules/<name>/      main.tf, variables.tf, outputs.tf, versions.tf, README.md
examples/<name>/     runnable root modules that call ../../modules/<name>
.github/workflows/   terraform-modules-ci.yml (fmt, validate, tflint, checkov on every PR)
.tflint.hcl          tflint rules (azurerm ruleset)
.checkov.yaml        checkov config, every skipped check has a reason
```

## Modules
| Module | What it creates | Key secure defaults |
|---|---|---|
| [network](modules/network) | VNet, subnets, NSGs, private DNS zones | NSG per subnet, deny Internet inbound, no default outbound |
| [managed-identity](modules/managed-identity) | User-assigned identity + federated credentials | No secrets (Workload Identity / GitHub OIDC) |
| [key-vault](modules/key-vault) | Key Vault + private endpoint | RBAC, purge protection, public access off |
| [log-analytics](modules/log-analytics) | Workspace + diagnostic settings | Entra ID only, daily cap |
| [storage-account](modules/storage-account) | Storage + blob private endpoint | No shared keys, no public access, versioning, soft delete |
| [sql](modules/sql) | SQL server + database + private endpoint | Entra ID-only, TDE, auditing to Log Analytics |
| [acr](modules/acr) | Container registry + private endpoint | Admin off, public off (Premium, cost note) |
| [aks](modules/aks) | AKS + user node pool | Private API option, Workload Identity, Azure RBAC, Policy |
| [vm](modules/vm) | Linux VM (+ optional Bastion) | No public IP, SSH key only, encryption at host |
| [app-service](modules/app-service) | Linux plan + .NET web app | HTTPS only, TLS 1.2, FTP off, VNet integration |
| [function-app](modules/function-app) | Linux plan + .NET function app | Storage via managed identity, HTTPS only, VNet integration |

## Examples
[vm-deployment](examples/vm-deployment), [app-service-dotnet](examples/app-service-dotnet), [aks-deployment](examples/aks-deployment).

## Cost notes
Premium-priced features are off by default: Azure Bastion (`bastion_enabled = false`).
ACR private endpoints need the Premium SKU (see [acr](modules/acr)).

## Versioning
- Releases are git tags using semantic versioning: `v1.0.0`.
  - MAJOR = breaking change (renamed variable, resource replaced), MINOR = new feature, PATCH = fix.
- Consumers pin a tag with `?ref=` so a module change never reaches an environment by surprise:
```hcl
source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/key-vault?ref=v1.0.0"
```

## How to release
1. Open a PR. CI must pass (fmt, validate, tflint, checkov). Squash merge to `main`.
2. Tag the merge commit and push the tag:
```powershell
git checkout main
git pull
git tag -a v1.1.0 -m "v1.1.0"
git push origin v1.1.0
```
3. In krconnects-infra, bump `?ref=v1.1.0` in a PR and review the plan.

## Run the checks locally
```powershell
terraform fmt -check -recursive
tflint --init
tflint --recursive --config "$PWD/.tflint.hcl"
checkov -d . --config-file .checkov.yaml
```
