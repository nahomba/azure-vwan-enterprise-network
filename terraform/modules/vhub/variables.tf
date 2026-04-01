variable "hub_name" {
  description = "Name of the Virtual Hub"
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

variable "virtual_wan_id" {
  description = "ID of the Virtual WAN"
  type        = string
}

variable "address_prefix" {
  description = "Address prefix for the Virtual Hub"
  type        = string
}

variable "vpn_scale_unit" {
  description = "Scale unit for VPN Gateway (1 = ~200 Mbps, 2 = ~400 Mbps, etc.)"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
