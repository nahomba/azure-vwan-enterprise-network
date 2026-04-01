# Virtual Hub
resource "azurerm_virtual_hub" "vhub" {
  name                = var.hub_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.virtual_wan_id
  address_prefix      = var.address_prefix
  tags                = var.tags

  # Hub routing preference
  hub_routing_preference = "ExpressRoute"

  # Virtual router auto-scale
  virtual_router_auto_scale_min_capacity = 2
}

# VPN Gateway
resource "azurerm_vpn_gateway" "vpn_gw" {
  name                = "vpngw-${var.hub_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = azurerm_virtual_hub.vhub.id
  scale_unit          = var.vpn_scale_unit
  tags                = var.tags

  # BGP is automatically enabled for Virtual Hub VPN Gateway
  # Active-Active is the default configuration
}
