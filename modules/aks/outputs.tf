output "id" {
  description = "Cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "Cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL, used as issuer in Workload Identity federated credentials."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  description = "Kubelet identity object ID. Give it AcrPull on the registry."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "node_resource_group" {
  description = "Resource group that holds the node VMs."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
