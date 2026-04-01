resource "azurerm_vpn_site" "onprem" {
  name                = "${var.connection_name}-site"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.virtual_wan_id
  tags                = var.tags

  link {
    name       = "primary-link"
    ip_address = var.onprem_public_ip
    bgp {
      asn             = var.onprem_bgp_asn
      peering_address = var.onprem_bgp_peering_address
    }
  }
}

# VPN Connection from Virtual Hub to On-Premises
resource "azurerm_vpn_gateway_connection" "hub_to_onprem" {
  name               = var.connection_name
  vpn_gateway_id     = var.vhub_vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.onprem.id

  vpn_link {
    name             = "primary-link"
    vpn_site_link_id = azurerm_vpn_site.onprem.link[0].id
    shared_key       = var.shared_key
    bgp_enabled      = true
    bandwidth_mbps   = 100
  }
}
