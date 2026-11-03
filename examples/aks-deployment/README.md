# Example: aks-deployment

## What it deploys
Resource group, VNet (AKS node subnet + private endpoint subnet), Log Analytics workspace,
ACR (Premium) with a private endpoint, a control-plane managed identity, an AKS cluster (system + user pool),
`AcrPull` for the kubelet identity, and a Workload Identity with a federated credential for `demo/workload-sa`.

## Cost note
ACR Premium and two AKS nodes are billed per hour. Destroy when you finish practising.
The API server is public here (limited to your IP) so you can use kubectl; use `private_cluster_enabled = true` for real environments.

## Prerequisites
- Azure CLI, Terraform 1.17+, kubectl and kubelogin (`az aks install-cli`).
- An Entra ID group for cluster admins, with you as a member (put its object ID in `admin_group_object_ids`).
- `Owner` or `User Access Administrator` on the subscription (role assignments).
- Encryption at host registered once per subscription:
```powershell
az feature register --namespace Microsoft.Compute --name EncryptionAtHost
az provider register --namespace Microsoft.Compute
```
- Your public IP for `api_server_authorized_ip_ranges`:
```powershell
Invoke-RestMethod https://api.ipify.org
```

## How to run
```powershell
az login
cd examples/aks-deployment
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: subscription_id, admin_group_object_ids, api_server_authorized_ip_ranges
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## How to verify
```powershell
az aks show --resource-group rg-tfmodaks-dev-cin-001 --name aks-tfmodaks-dev-cin-001 --query "{oidc:oidcIssuerProfile.enabled, wi:securityProfile.workloadIdentity.enabled, localAccounts:disableLocalAccounts, policy:addonProfiles.azurepolicy.enabled}"
az aks get-credentials --resource-group rg-tfmodaks-dev-cin-001 --name aks-tfmodaks-dev-cin-001 --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
kubectl get nodes -o wide
kubectl get pods -n kube-system
az acr show --name crtfmodaksdevcin001 --query "{admin:adminUserEnabled, public:publicNetworkAccess}"
```

## Clean up
```powershell
terraform destroy
```
