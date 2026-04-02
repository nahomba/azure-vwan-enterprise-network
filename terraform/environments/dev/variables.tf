variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for East US resources"
  type        = string
  default     = "eastus"
}

variable "vwan_name" {
  description = "Name of the Virtual WAN"
  type        = string
}

variable "hub_eastus_name" {
  description = "Name of the Virtual Hub in East US"
  type        = string
}

variable "hub_eastus_address_prefix" {
  description = "Address prefix for the Virtual Hub in East US"
  type        = string
}

variable "hub_westeu_name" {
  description = "Name of the Virtual Hub in West EU"
  type        = string
  default     = "vhub-westeu-dev"
}

variable "hub_westeu_address_prefix" {
  description = "Address prefix for the Virtual Hub in West EU"
  type        = string
  default     = "10.10.0.0/23"
}

variable "firewall_eastus_name" {
  description = "Name of the Azure Firewall in East US"
  type        = string
}

variable "firewall_westeu_name" {
  description = "Name of the Azure Firewall in West EU"
  type        = string
  default     = "afw-vwan-westeu"
}

variable "appgw_eastus_name" {
  description = "Name of the Application Gateway in East US"
  type        = string
}

variable "appgw_westeu_name" {
  description = "Name of the Application Gateway in West EU"
  type        = string
  default     = "appgw-westeu-dev"
}

variable "frontdoor_name" {
  description = "Name of the Front Door"
  type        = string
}

variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}

variable "vpn_shared_key" {
  description = "Shared key for VPN connection"
  type        = string
  sensitive   = true
  default     = "VpnSharedKey123!@#"
}

variable "ssl_cert_path" {
  type    = string
  default = ""
}

variable "ssl_cert_password" {
  type    = string
  default = ""
}

variable "enable_westeu" {
  description = "Enable West Europe region deployment"
  type        = bool
  default     = false
}

variable "hub_westeu_config" {
  description = "West Europe hub configuration"
  type = object({
    name           = string
    location       = string
    address_prefix = string
  })
  default = {
    name           = "vhub-westeu-dev"
    location       = "westeurope"
    address_prefix = "10.10.0.0/23"
  }
}

variable "spoke_prod_westeu_config" {
  description = "West Europe production spoke configuration"
  type = object({
    name     = string
    location = string
    cidr     = string
    subnets  = map(string)
  })
  default = {
    name     = "vnet-spoke-prod-westeu"
    location = "westeurope"
    cidr     = "10.11.0.0/16"
    subnets = {
      web   = "10.11.1.0/24"
      app   = "10.11.2.0/24"
      data  = "10.11.3.0/24"
      appgw = "10.11.250.0/24"
    }
  }
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "spoke_dev_name" {
  type = string
}

variable "spoke_dev_address_space" {
  type = list(string)
}

variable "spoke_dev_subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

# ============================================
# Application Gateway SKU
# ============================================
variable "appgw_sku" {
  description = "Application Gateway SKU configuration"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

# ============================================
# Firewall SKU Tier
# ============================================
variable "firewall_sku_tier" {
  description = "Azure Firewall SKU Tier"
  type        = string
}