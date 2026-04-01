variable "dns_zone_name" {
  description = "Private DNS zone name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_links" {
  description = "VNet links (name => vnet_id)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}