variable "name" {
  description = "Cluster name, for example aks-krconnects-dev-cin-001."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "dns_prefix" {
  description = "DNS prefix for the API server, for example krconnects-dev."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version, for example 1.34. null = AKS default version."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "Free (no SLA) or Standard (uptime SLA, recommended for prod, extra cost)."
  type        = string
  default     = "Free"
}

variable "private_cluster_enabled" {
  description = "Private API server: reachable only from the VNet (or peered networks / VPN)."
  type        = bool
  default     = true
}

variable "api_server_authorized_ip_ranges" {
  description = "Public IP ranges allowed to reach a public API server. Ignored for a private cluster."
  type        = list(string)
  default     = []
}

variable "identity_id" {
  description = "User-assigned managed identity ID for the cluster control plane."
  type        = string
}

variable "identity_principal_id" {
  description = "Principal ID of that identity. It gets Network Contributor on the node subnet."
  type        = string
}

variable "node_subnet_id" {
  description = "Subnet ID for the nodes."
  type        = string
}

variable "tenant_id" {
  description = "Entra ID tenant ID for cluster authentication."
  type        = string
}

variable "admin_group_object_ids" {
  description = "Entra ID group object IDs that get cluster admin."
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Container Insights."
  type        = string
}

variable "os_sku" {
  description = "Node OS: AzureLinux (small, hardened) or Ubuntu."
  type        = string
  default     = "AzureLinux"
}

variable "zones" {
  description = "Availability zones for the node pools, for example [\"1\", \"2\", \"3\"]."
  type        = list(string)
  default     = []
}

variable "system_node_vm_size" {
  description = "VM size of the system node pool."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "system_node_count" {
  description = "Number of system nodes (use 3 in prod)."
  type        = number
  default     = 1
}

variable "user_node_vm_size" {
  description = "VM size of the user node pool (runs your apps)."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "user_node_count" {
  description = "Number of user nodes."
  type        = number
  default     = 1
}

variable "host_encryption_enabled" {
  description = "Encrypt node temp disks and caches on the host. Needs the EncryptionAtHost feature registered on the subscription."
  type        = bool
  default     = true
}

variable "service_cidr" {
  description = "Kubernetes service range. Must not overlap with the VNet."
  type        = string
  default     = "10.100.0.0/16"
}

variable "dns_service_ip" {
  description = "Cluster DNS IP, must be inside service_cidr."
  type        = string
  default     = "10.100.0.10"
}

variable "pod_cidr" {
  description = "Pod range for Azure CNI Overlay. Must not overlap with the VNet."
  type        = string
  default     = "10.244.0.0/16"
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
