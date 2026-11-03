variable "name" {
  description = "Storage account name (3-24 lowercase letters/numbers, globally unique), for example stkrcdevcin001."
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

variable "account_replication_type" {
  description = "Replication: LRS, ZRS, GRS, GZRS. ZRS survives a zone outage."
  type        = string
  default     = "ZRS"
}

variable "blob_soft_delete_days" {
  description = "Days deleted blobs and containers can be restored."
  type        = number
  default     = 7
}

variable "containers" {
  description = "Private blob containers to create."
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the blob private endpoint."
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID of the privatelink.blob.core.windows.net private DNS zone."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
