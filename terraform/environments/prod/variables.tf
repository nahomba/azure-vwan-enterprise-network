# ============================================================================
# PRODUCTION VARIABLES
# ============================================================================

# ============================================================================
# GENERAL
# ============================================================================

variable "environment" {
  type    = string
  default = "prod"
}

variable "location_eastus" {
  type    = string
  default = "eastus"
}

variable "location_westeu" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type    = string
  default = "rg-vwan-prod"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "Azure-vWAN-Enterprise"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# ============================================================================
# VWAN
# ============================================================================

variable "vwan_name" {
  type    = string
  default = "vwan-prod"
}

# ============================================================================
# HUBS
# ============================================================================

variable "vhub_name_prefix" {
  type    = string
  default = "vhub"
}

variable "vhub_eastus_address_prefix" {
  type    = string
  default = "10.100.0.0/23"
}

variable "vhub_westeu_address_prefix" {
  type    = string
  default = "10.110.0.0/23"
}

# ============================================================================
# SPOKES
# ============================================================================

variable "spoke_eastus_address_space" {
  type    = list(string)
  default = ["10.101.0.0/16"]
}

variable "spoke_westeu_address_space" {
  type    = list(string)
  default = ["10.111.0.0/16"]
}

# ============================================================================
# VM (✅ FIXED — SSH ONLY)
# ============================================================================

variable "vm_admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

# ❌ REMOVED (NOT NEEDED ANYMORE)
# variable "vm_admin_password"

# ============================================================================
# APPLICATION GATEWAY
# ============================================================================

variable "appgateway_name" {
  type    = string
  default = "appgw-prod"
}

variable "ssl_cert_password" {
  type      = string
  sensitive = true
}

# ============================================================================
# MONITORING
# ============================================================================

variable "log_analytics_name" {
  type    = string
  default = "law-vwan-prod"
}

variable "admin_email" {
  type    = string
  default = "admin@example.com"
}