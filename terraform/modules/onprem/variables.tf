variable "onprem_vnet_name" {
  description = "Name of the on-premises VNet"
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

variable "address_space" {
  description = "Address space for on-premises VNet"
  type        = list(string)
}

variable "gateway_subnet" {
  description = "Gateway subnet CIDR"
  type        = string
}

variable "vpn_gateway_name" {
  description = "Name of the VPN Gateway"
  type        = string
}

variable "bgp_asn" {
  description = "BGP ASN for on-premises"
  type        = number
  default     = 65001
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
variable "ssh_public_key" {
  description = "SSH public key for Linux VM authentication"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDExample... azureuser@localhost"
}
