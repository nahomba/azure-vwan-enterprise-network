variable "route_table_name" {
  description = "Route table name"
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

variable "disable_bgp_route_propagation" {
  description = "Disable BGP route propagation"
  type        = bool
  default     = false
}

variable "routes" {
  description = "Map of routes"
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}
}

variable "subnet_id" {
  description = "Subnet ID to associate with route table"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}