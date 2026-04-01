terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "ombasaqn23554"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  # Authentication handled by azure/login action via OIDC
}

# -----------------------------
# LOCALS (DEV + FINOPS)
# -----------------------------
locals {
  common_tags = merge(var.tags, {
    Environment = "dev"
    Purpose     = "Demo"
    ManagedBy   = "Terraform"
    Project     = "vWAN-Enterprise"
    CostCenter  = "IT-Infrastructure"
    Owner       = "DevOps-Team"
  })
}

# -----------------------------
# RESOURCE GROUP
# -----------------------------
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# -----------------------------
# MONITORING
# -----------------------------
module "monitoring" {
  source              = "../../modules/monitoring"
  workspace_name      = var.log_analytics_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  alert_email         = var.alert_email
  tags                = local.common_tags
}

# -----------------------------
# GLOBAL NETWORK
# -----------------------------
module "vwan" {
  source              = "../../modules/vwan"
  vwan_name           = var.vwan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.common_tags
}

# -----------------------------
# VIRTUAL HUB
# -----------------------------
module "vhub_eastus" {
  source              = "../../modules/vhub"
  hub_name            = var.hub_eastus_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  virtual_wan_id      = module.vwan.vwan_id
  address_prefix      = var.hub_eastus_address_prefix
  vpn_scale_unit      = 1
  tags                = local.common_tags
}

# -----------------------------
# FIREWALL 
# -----------------------------
module "firewall_eastus" {
  source              = "../../modules/firewall"
  name                = var.firewall_eastus_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  virtual_hub_id      = module.vhub_eastus.vhub_id
  sku_name            = "AZFW_Hub"
  sku_tier            = "Basic"
  tags                = local.common_tags
}

module "routing_intent_eastus" {
  source              = "../../modules/routing-intent"
  virtual_hub_id      = module.vhub_eastus.vhub_id
  firewall_id = module.firewall_eastus.firewall_id
  resource_group_name = azurerm_resource_group.main.name
}

# -----------------------------
# SPOKE NETWORK
# -----------------------------
module "spoke_dev" {
  source              = "../../modules/spoke"
  vnet_name           = "vnet-dev-eastus"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = ["10.1.0.0/16"]

  subnet_names = [
    "subnet-appgw",
    "subnet-web"
  ]

  subnet_prefixes = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]

  virtual_hub_id = module.vhub_eastus.vhub_id
  tags           = local.common_tags
}

# -----------------------------
# VIRTUAL MACHINE
# -----------------------------
module "vm_dev" {
  source              = "../../modules/vm"
  vm_name             = "vm-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.spoke_dev.subnet_ids["subnet-web"]
  vm_size             = "Standard_B2s"
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  tags                = merge(local.common_tags, { Tier = "Dev" })
}

# -----------------------------
# APPLICATION GATEWAY
# -----------------------------
module "appgateway_dev" {
  source              = "../../modules/appgateway"
  name                = var.appgw_eastus_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.spoke_dev.subnet_ids["subnet-appgw"]
  tags                = local.common_tags
}
