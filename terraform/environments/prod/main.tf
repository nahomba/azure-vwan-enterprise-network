terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "Azure-vWAN-Enterprise"
    ManagedBy   = "Terraform"
  }
}

# ============================================================================
# RESOURCE GROUP
# ============================================================================

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location_eastus
  tags     = merge(var.tags, local.common_tags)
}

# ============================================================================
# VIRTUAL WAN
# ============================================================================

resource "azurerm_virtual_wan" "vwan" {
  name                           = var.vwan_name
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = var.location_eastus
  type                           = "Standard"
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  tags                           = merge(var.tags, local.common_tags)
}

# ============================================================================
# VIRTUAL HUBS
# ============================================================================

module "vhub_eastus" {
  source              = "../../modules/vhub"
  hub_name            = "${var.vhub_name_prefix}-eastus-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.vhub_eastus_address_prefix
  tags                = merge(var.tags, local.common_tags)
}

module "vhub_westeu" {
  source              = "../../modules/vhub"
  hub_name            = "${var.vhub_name_prefix}-westeu-${var.environment}" # ✅ FIXED
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_westeu
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.vhub_westeu_address_prefix
  tags                = merge(var.tags, local.common_tags)
}

# ============================================================================
# SPOKE NETWORKS
# ============================================================================

module "spoke_eastus" {
  source              = "../../modules/spoke"
  vnet_name           = "vnet-spoke-${var.environment}-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  address_space       = var.spoke_eastus_address_space

  subnet_names    = ["subnet-appgw", "subnet-web", "subnet-app", "subnet-data"]
  subnet_prefixes = ["10.101.0.0/24", "10.101.1.0/24", "10.101.2.0/24", "10.101.3.0/24"]

  virtual_hub_id = module.vhub_eastus.vhub_id
  tags           = merge(var.tags, local.common_tags)
}

module "spoke_westeu" {
  source              = "../../modules/spoke"
  vnet_name           = "vnet-spoke-${var.environment}-westeu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_westeu
  address_space       = var.spoke_westeu_address_space

  subnet_names    = ["subnet-appgw", "subnet-web", "subnet-app", "subnet-data"]
  subnet_prefixes = ["10.111.0.0/24", "10.111.1.0/24", "10.111.2.0/24", "10.111.3.0/24"]

  virtual_hub_id = module.vhub_westeu.vhub_id
  tags           = merge(var.tags, local.common_tags)
}

# ============================================================================
# AZURE FIREWALL (VWAN HUB MODE )
# ============================================================================

module "firewall_eastus" {
  source              = "../../modules/firewall"
  name                = "afw-eastus-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  virtual_hub_id      = module.vhub_eastus.vhub_id
  tags                = merge(var.tags, local.common_tags)
}

module "firewall_westeu" {
  source              = "../../modules/firewall"
  name                = "afw-westeu-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_westeu
  virtual_hub_id      = module.vhub_westeu.vhub_id
  tags                = merge(var.tags, local.common_tags)
}

# ============================================================================
# APPLICATION GATEWAY
# ============================================================================

module "appgateway_eastus" {
  source              = "../../modules/appgateway"
  name                = "${var.appgateway_name}-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  subnet_id           = module.spoke_eastus.subnet_ids["subnet-appgw"]

  tags = local.common_tags
}

module "appgateway_westeu" {
  source              = "../../modules/appgateway"
  name                = "${var.appgateway_name}-westeu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_westeu
  subnet_id           = module.spoke_westeu.subnet_ids["subnet-appgw"]

  tags = local.common_tags
}

# ============================================================================
# MONITORING
# ============================================================================

module "monitoring" {
  source              = "../../modules/monitoring"
  workspace_name      = var.log_analytics_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  alert_email         = var.admin_email
  tags                = merge(var.tags, local.common_tags)
}

# ============================================================================
# VIRTUAL MACHINES (SSH ONLY)
# ============================================================================

module "vm_eastus" {
  source              = "../../modules/vm"
  vm_name             = "vm-${var.environment}-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_eastus
  subnet_id           = module.spoke_eastus.subnet_ids["subnet-web"]

  admin_username = var.vm_admin_username
  ssh_public_key = var.ssh_public_key

  tags = merge(var.tags, local.common_tags)
}

module "vm_westeu" {
  source              = "../../modules/vm"
  vm_name             = "vm-${var.environment}-westeu"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_westeu
  subnet_id           = module.spoke_westeu.subnet_ids["subnet-web"]

  admin_username = var.vm_admin_username
  ssh_public_key = var.ssh_public_key

  tags = merge(var.tags, local.common_tags)
}

# ============================================================================
# FRONT DOOR
# ============================================================================

module "frontdoor" {
  source              = "../../modules/frontdoor"
  frontdoor_name      = "fd-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name

  appgw_eastus_id = module.appgateway_eastus.id
  appgw_westeu_id = module.appgateway_westeu.id

  enable_westeu_origin = true

  tags = var.tags
}

# ============================================================================
# DIAGNOSTICS (unchanged)
# ============================================================================

resource "azurerm_monitor_diagnostic_setting" "appgw_eastus_diag" {
  name                       = "appgw-eastus-diagnostics"
  target_resource_id         = module.appgateway_eastus.id
  log_analytics_workspace_id = module.monitoring.workspace_id

  enabled_log { category = "ApplicationGatewayAccessLog" }
  enabled_log { category = "ApplicationGatewayPerformanceLog" }
  enabled_log { category = "ApplicationGatewayFirewallLog" }

  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "appgw_westeu_diag" {
  name                       = "appgw-westeu-diagnostics"
  target_resource_id         = module.appgateway_westeu.id
  log_analytics_workspace_id = module.monitoring.workspace_id

  enabled_log { category = "ApplicationGatewayAccessLog" }
  enabled_log { category = "ApplicationGatewayPerformanceLog" }
  enabled_log { category = "ApplicationGatewayFirewallLog" }

  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "firewall_eastus_diag" {
  name                       = "fw-eastus-diagnostics"
  target_resource_id         = module.firewall_eastus.firewall_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  enabled_log { category = "AzureFirewallApplicationRule" }
  enabled_log { category = "AzureFirewallNetworkRule" }
  enabled_log { category = "AzureFirewallDnsProxy" }

  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "firewall_westeu_diag" {
  name                       = "fw-westeu-diagnostics"
  target_resource_id         = module.firewall_westeu.firewall_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  enabled_log { category = "AzureFirewallApplicationRule" }
  enabled_log { category = "AzureFirewallNetworkRule" }
  enabled_log { category = "AzureFirewallDnsProxy" }

  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "vm_eastus_diag" {
  name                       = "vm-eastus-diagnostics"
  target_resource_id         = module.vm_eastus.vm_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "vm_westeu_diag" {
  name                       = "vm-westeu-diagnostics"
  target_resource_id         = module.vm_westeu.vm_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  metric { category = "AllMetrics" }
}