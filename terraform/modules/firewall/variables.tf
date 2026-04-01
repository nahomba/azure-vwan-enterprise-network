variable "name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Azure Firewall (AzureFirewallSubnet) - only for VNet mode"
  type        = string
  default     = null
}

variable "virtual_hub_id" {
  description = "Virtual Hub ID - only for Hub mode"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name - AZFW_VNet or AZFW_Hub"
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "SKU tier - Standard, Premium, or Basic"
  type        = string
  default     = "Premium"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
