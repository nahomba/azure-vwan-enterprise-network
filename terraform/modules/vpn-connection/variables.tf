variable "connection_name" {
  description = "Name of the VPN connection"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
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

variable "vhub_vpn_gateway_id" {
  description = "ID of the Virtual Hub VPN Gateway"
  type        = string
}

variable "onprem_public_ip" {
  description = "Public IP of the on-premises VPN gateway"
  type        = string
}

variable "onprem_bgp_asn" {
  description = "BGP ASN of the on-premises network"
  type        = number
}

variable "onprem_bgp_peering_address" {
  description = "BGP peering address of the on-premises gateway"
  type        = string
}

variable "shared_key" {
  description = "Shared key for VPN connection"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}