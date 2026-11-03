# Example: vm-deployment

## What it deploys
Resource group, VNet (VM, private endpoint and Bastion subnets with NSGs), Key Vault with a private
endpoint, and a Linux VM with no public IP. The VM's managed identity gets `Key Vault Secrets User`.
Azure Bastion is **off** by default (premium cost).

## Prerequisites
- Azure CLI, Terraform 1.17+, an SSH key (`ssh-keygen -t ed25519`).
- `Owner` or `User Access Administrator` on the subscription (the example creates a role assignment).
- Encryption at host registered once per subscription (takes a few minutes):
```powershell
az feature register --namespace Microsoft.Compute --name EncryptionAtHost
az feature show --namespace Microsoft.Compute --name EncryptionAtHost --query properties.state
az provider register --namespace Microsoft.Compute
```

## How to run
```powershell
az login
cd examples/vm-deployment
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: subscription_id and admin_ssh_public_key (Get-Content ~/.ssh/id_ed25519.pub)
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## How to verify
```powershell
az vm show --resource-group rg-tfmodvm-dev-cin-001 --name vm-tfmodvm-dev-cin-001 --show-details --query "{power:powerState, publicIp:publicIps, privateIp:privateIps}"
az keyvault show --name kv-tfmodvm-dev-cin-001 --query "properties.{rbac:enableRbacAuthorization, public:publicNetworkAccess, purge:enablePurgeProtection}"
az vm run-command invoke --resource-group rg-tfmodvm-dev-cin-001 --name vm-tfmodvm-dev-cin-001 --command-id RunShellScript --scripts "nslookup kv-tfmodvm-dev-cin-001.vault.azure.net"
```
Expected: no public IP, RBAC true, public access Disabled, and the vault name resolves to a `10.10.2.x` private IP.

## Clean up
```powershell
terraform destroy
```
The vault is soft-deleted with purge protection, so the name `kv-tfmodvm-dev-cin-001` stays reserved for 7 days.
To re-run sooner, change `project` in `terraform.tfvars`.
