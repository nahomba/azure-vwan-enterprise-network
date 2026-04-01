variable "private_endpoint_name" {
  description = "Private endpoint name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "target_resource_id" {
  description = "Target resource ID (e.g., Storage Account, SQL Server)"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names (e.g., ['blob'], ['sqlServer'])"
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Whether connection requires manual approval"
  type        = bool
  default     = false
}

variable "request_message" {
  description = "Request message for manual approval"
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for DNS integration"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}