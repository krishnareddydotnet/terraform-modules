# Example: app-service-dotnet

## What it deploys
Resource group, VNet (delegated app subnet + private endpoint subnet), Key Vault with a private endpoint,
Linux App Service plan (B1) + .NET 10 web app with VNet integration, a Key Vault reference app setting,
and a Log Analytics workspace with diagnostic settings for the vault and the web app.

## Prerequisites
- Azure CLI, Terraform 1.17+.
- `Owner` or `User Access Administrator` on the subscription (the example creates a role assignment).

## How to run
```powershell
az login
cd examples/app-service-dotnet
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: subscription_id
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## How to verify
```powershell
az webapp show --resource-group rg-tfmodapp-dev-cin-001 --name app-tfmodapp-dev-cin-001 --query "{httpsOnly:httpsOnly, tls:siteConfig.minTlsVersion, ftps:siteConfig.ftpsState, vnet:virtualNetworkSubnetId}"
az webapp identity show --resource-group rg-tfmodapp-dev-cin-001 --name app-tfmodapp-dev-cin-001
az monitor diagnostic-settings list --resource (az webapp show --resource-group rg-tfmodapp-dev-cin-001 --name app-tfmodapp-dev-cin-001 --query id -o tsv)
curl.exe -I https://app-tfmodapp-dev-cin-001.azurewebsites.net
```
The `DemoSecret` Key Vault reference shows an error until a secret named `demo-secret` exists in the vault.
Public access to the vault is off, so add it from inside the VNet (or briefly allow your IP).

## Clean up
```powershell
terraform destroy
```
The vault is soft-deleted with purge protection, so the name `kv-tfmodapp-dev-cin-001` stays reserved for 7 days.
