variable "site_name" {
  description = "VPN site name"
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

variable "vwan_id" {
  description = "Virtual WAN ID"
  type        = string
}

variable "vpn_gateway_id" {
  description = "VPN Gateway ID"
  type        = string
}

variable "onprem_public_ip" {
  description = "On-premises VPN device public IP"
  type        = string
}

variable "onprem_address_space" {
  description = "On-premises address space"
  type        = list(string)
}

variable "shared_key" {
  description = "VPN shared key"
  type        = string
  sensitive   = true
}

variable "bgp_asn" {
  description = "BGP ASN for on-premises"
  type        = number
  default     = 65515
}

variable "bgp_peering_address" {
  description = "BGP peering address for on-premises"
  type        = string
  default     = "192.168.255.254"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}