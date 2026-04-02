# Resource Group
resource_group_name = "rg-vwan-enterprise-dev"
location            = "eastus"
environment         = "dev"

# Virtual WAN
vwan_name = "vwan-enterprise-dev"

# Virtual Hub
hub_eastus_name           = "vhub-eastus-dev"
hub_eastus_address_prefix = "10.0.0.0/23"

# Spoke Networks
spoke_dev_name          = "vnet-spoke-dev"
spoke_dev_address_space = ["10.1.0.0/16"]

spoke_dev_subnets = {
  web = {
    name             = "snet-web"
    address_prefixes = ["10.1.1.0/24"]
  }
  app = {
    name             = "snet-app"
    address_prefixes = ["10.1.2.0/24"]
  }
  data = {
    name             = "snet-data"
    address_prefixes = ["10.1.3.0/24"]
  }
}

# Firewall
firewall_eastus_name = "azfw-eastus-dev"
firewall_sku_tier    = "Standard"

# App Gateway
appgw_eastus_name = "appgw-eastus-dev"
appgw_sku = {
  name     = "Standard_v2"
  tier     = "Standard_v2"
  capacity = 2
}

# Front Door
frontdoor_name = "afd-enterprise-dev"

# Monitoring
log_analytics_name = "law-vwan-dev"
alert_email = "queenivanah@outlook.com"

# Tags
tags = {
  Environment = "dev"
  Project     = "VWAN-Enterprise"
  ManagedBy   = "Terraform"
}

# VM
admin_username = "azureadmin"

# SSL (ONLY path stays here)
ssl_cert_path = "./certs/dev-cert.pfx"
