# vm

Linux VM (Ubuntu 24.04) with no public IP, plus optional Azure Bastion.

## Secure defaults
- No public IP. SSH key only (`disable_password_authentication = true`).
- System-assigned managed identity.
- Encryption at host, Trusted Launch (secure boot + vTPM).
- Automatic OS patching by the platform. Managed boot diagnostics.

## Cost note
`bastion_enabled = false` by default. Azure Bastion is billed per hour even when idle, plus its public IP.
Turn it on only while you need it, and destroy it after.

## Prerequisites
Encryption at host needs a one-time feature registration:
`az feature register --namespace Microsoft.Compute --name EncryptionAtHost`

## Usage
```hcl
module "vm" {
  source = "git::https://github.com/krishnareddydotnet/terraform-modules.git//modules/vm?ref=v1.0.0"

  name                 = "vm-krconnects-dev-cin-001"
  resource_group_name  = "rg-krconnects-dev-cin-001"
  subnet_id            = module.network.subnet_ids["snet-vm-krconnects-dev-cin-001"]
  admin_ssh_public_key = file("~/.ssh/id_ed25519.pub")
}
```

## Outputs
`id`, `name`, `private_ip_address`, `principal_id`.
