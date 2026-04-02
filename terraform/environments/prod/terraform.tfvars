# =========================
# GLOBAL SETTINGS
# =========================
resource_group_name = "rg-vwan-enterprise-prod"
environment         = "prod"

tags = {
  Environment = "prod"
  Project     = "VWAN-Enterprise"
  ManagedBy   = "Terraform"
}

admin_username = "azureadmin"


# =========================
# REGIONS
# =========================
primary_location   = "eastus"
secondary_location = "westeurope"


# =========================
# VIRTUAL WAN
# =========================
vwan_name = "vwan-enterprise-prod"


# =========================
# VIRTUAL HUBS
# =========================
hub_eastus_name           = "vhub-eastus-prod"
hub_eastus_address_prefix = "10.100.0.0/23"

hub_weu_name              = "vhub-weu-prod"
hub_weu_address_prefix    = "10.110.0.0/23"


# =========================
# SPOKE NETWORKS
# =========================
spoke_eastus_name          = "vnet-spoke-eus-prod"
spoke_eastus_address_space = ["10.101.0.0/16"]

spoke_weu_name             = "vnet-spoke-weu-prod"
spoke_weu_address_space    = ["10.111.0.0/16"]


# Subnets (same structure for both regions)
spoke_subnets = {
  appgw = {
    name             = "snet-appgw"
    address_prefixes = ["10.101.0.0/24"]
  }
  web = {
    name             = "snet-web"
    address_prefixes = ["10.101.1.0/24"]
  }
  app = {
    name             = "snet-app"
    address_prefixes = ["10.101.2.0/24"]
  }
  data = {
    name             = "snet-data"
    address_prefixes = ["10.101.3.0/24"]
  }
}


# =========================
# FIREWALL
# =========================
firewall_eastus_name = "azfw-eastus-prod"
firewall_weu_name    = "azfw-weu-prod"

firewall_sku_tier = "Standard"


# =========================
# APPLICATION GATEWAY
# =========================
appgw_eastus_name = "appgw-eastus-prod"
appgw_weu_name    = "appgw-weu-prod"

appgw_sku = {
  name     = "WAF_v2"
  tier     = "WAF_v2"
  capacity = 2
}


# =========================
# FRONT DOOR
# =========================
frontdoor_name = "afd-enterprise-prod"


# =========================
# MONITORING
# =========================
log_analytics_name = "law-vwan-prod"
alert_email        = "queenivanah@outlook.com"