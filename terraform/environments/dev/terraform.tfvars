# Resource Group
resource_group_name = "rg-vwan-enterprise-dev"
location            = "eastus"
environment         = "dev"

# Virtual WAN
vwan_name = "vwan-enterprise-dev"

# Virtual Hub - East US
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

# Azure Firewall
firewall_eastus_name = "azfw-eastus-dev"
firewall_sku_tier    = "Standard"

# Application Gateway
appgw_eastus_name = "appgw-eastus-dev"
appgw_sku = {
  name     = "Standard_v2"
  tier     = "Standard_v2"
  capacity = 2
}

# Azure Front Door
frontdoor_name = "afd-enterprise-dev"

# Monitoring
log_analytics_name = "law-vwan-dev"
alert_email = "nahqueeniva@yahoo.com"

# Tags
tags = {
  Environment = "dev"
  Project     = "VWAN-Enterprise"
  ManagedBy   = "Terraform"
}

# VM Configuration
admin_username = "azureadmin"

# SSL Configuration
ssl_cert_path     = "./certs/dev-cert.pfx"
ssl_cert_password = "placeholder"

# SSH Key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL+Bf+005ulaqNQi/D5UKVzush+PlgkWWJ2T2zGXBZI1dlhEGp1/0rW0Bm5+H6CEe920AgLecUesfM+Oz0Zvl+f2H/l9nF3uKZ3aGputv6hywO6Fg+4gYk7Z86G7NgBgE4lROVZSWsmAaXfgmLve7gT0AYlphtBLGPAHJKg5Dls2VUv07cG52KxTmuzBnBuKIsr6rBv4yDg7/WnDBjbemvIp3sMxllFZI2sol0SX2mwdxOUvyOEdphj/QMBTr+iSrFHwNMSuneumSB7OtqGthKzfuardAgCd2wBBiN6T/7L5/BF/DPfsib715a05iBOQA4K6UEjvtVwykaludjj3K+j011jjgLDtR9VN46eYEJ7QRM3ecbDOpoBVbiccZB/MwIlRhT9chPsm3qkOdV9FP08LnMKJAAjV+nGR2X0gpO4BKhFN5338ELklAWxNrkSZlRavBhe/OYokkRUymDrJ5iZzb8iTWVCT1/Y1FIfgh/ipkVPHSW3FcNVFtoxagY55HttEA1hAKu6HbEtZwjaJFaXCJmSnrRM9I8u8ErwYgOBXgjPOubh966luUDMGu91STZSv4QJ31aJuBC8D79qGC4Q2NZwb9fiJWSvYNjGg9A3NBuMwlQiiA7xiDLlzqwf6Vyqp98mcO/6Z3D9LSrMA6fvBiiH8DYHGBSO7MVPVSLsw== queenivanah@outlook.com"
