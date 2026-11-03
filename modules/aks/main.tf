# With a custom VNet, the cluster identity must manage the subnet (load balancers, IPs).
resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.node_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.identity_principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  private_cluster_enabled = var.private_cluster_enabled

  api_server_access_profile {
    authorized_ip_ranges = var.private_cluster_enabled ? [] : var.api_server_authorized_ip_ranges
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  # Workload Identity: pods get Entra ID tokens through a federated credential. No secrets in the cluster.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Entra ID login + Azure RBAC for Kubernetes authorization.
  # local_account_disabled removes the static admin kubeconfig (a "break glass" credential that bypasses Entra ID).
  role_based_access_control_enabled = true
  local_account_disabled            = true

  azure_active_directory_role_based_access_control {
    tenant_id              = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  # Azure Policy add-on (Gatekeeper): enforces rules like "no privileged containers".
  azure_policy_enabled = true

  # Container Insights, authenticated with managed identity.
  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  # Secrets Store CSI driver: mount Key Vault secrets into pods.
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  automatic_upgrade_channel    = "patch"
  node_os_upgrade_channel      = "NodeImage"
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    # Network policy lets you restrict pod-to-pod traffic (default allow-all otherwise).
    network_policy = "cilium"
    pod_cidr       = var.pod_cidr
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  # Manual = you manage node pools yourself (Auto = node auto-provisioning / Karpenter).
  node_provisioning_profile {
    mode = "Manual"
  }

  # System pool runs only critical add-ons (CoreDNS, metrics). Apps run on the user pool.
  default_node_pool {
    name                         = "system"
    vm_size                      = var.system_node_vm_size
    node_count                   = var.system_node_count
    vnet_subnet_id               = var.node_subnet_id
    os_sku                       = var.os_sku
    zones                        = var.zones
    host_encryption_enabled      = var.host_encryption_enabled
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "systemtmp"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  tags = var.tags

  depends_on = [azurerm_role_assignment.network_contributor]
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                    = "user"
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.this.id
  mode                    = "User"
  vm_size                 = var.user_node_vm_size
  node_count              = var.user_node_count
  vnet_subnet_id          = var.node_subnet_id
  os_sku                  = var.os_sku
  zones                   = var.zones
  host_encryption_enabled = var.host_encryption_enabled
  tags                    = var.tags

  upgrade_settings {
    max_surge = "10%"
  }
}
