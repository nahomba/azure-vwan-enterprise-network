# Firewall Policy with IDPS
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_tier
  tags                = var.tags

  threat_intelligence_mode = "Deny"

  dns {
    proxy_enabled = true
  }

  # IDPS only available in Premium tier
  dynamic "intrusion_detection" {
    for_each = var.sku_tier == "Premium" ? [1] : []
    content {
      mode = "Deny"
    }
  }
}

# Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "network-rules"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  network_rule_collection {
    name     = "allow-internal"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-vnet-traffic"
      protocols             = ["Any"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["*"]
    }
  }
}

# Public IP for Firewall (only for VNet mode)
resource "azurerm_public_ip" "fw_pip" {
  count               = var.sku_name == "AZFW_VNet" ? 1 : 0
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  threat_intel_mode   = "Deny"
  tags                = var.tags

  # IP Configuration for VNet mode
  dynamic "ip_configuration" {
    for_each = var.sku_name == "AZFW_VNet" ? [1] : []
    content {
      name                 = "fw-ipconfig"
      subnet_id            = var.subnet_id
      public_ip_address_id = azurerm_public_ip.fw_pip[0].id
    }
  }

  # Virtual Hub configuration for Hub mode
  dynamic "virtual_hub" {
    for_each = var.sku_name == "AZFW_Hub" ? [1] : []
    content {
      virtual_hub_id  = var.virtual_hub_id
      public_ip_count = 1
    }
  }
}
