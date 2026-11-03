variable "name" {
  description = "Identity name, for example id-krconnects-dev-cin-001."
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

variable "federated_credentials" {
  description = <<-EOT
    Optional federated credentials (trust a token from another identity provider, no secret needed).
    The map key is the credential name.
    - AKS Workload Identity: issuer = AKS OIDC issuer URL, subject = "system:serviceaccount:<namespace>:<service-account>".
    - GitHub OIDC: issuer = "https://token.actions.githubusercontent.com", subject = "repo:<owner>/<repo>:environment:dev".
  EOT
  type = map(object({
    issuer  = string
    subject = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
