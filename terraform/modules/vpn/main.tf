# VPN Site
resource "azurerm_vpn_site" "site" {
  name                = var.site_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.vwan_id
  address_cidrs       = var.onprem_address_space
  tags                = var.tags

  link {
    name       = "${var.site_name}-link"
    ip_address = var.onprem_public_ip

    # BGP Configuration
    bgp {
      asn             = var.bgp_asn
      peering_address = var.bgp_peering_address
    }
  }
}
resource "azurerm_vpn_gateway_connection" "connection" {
  name               = "${var.site_name}-connection"
  vpn_gateway_id     = var.vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.site.id

  vpn_link {
    name             = "${var.site_name}-link"
    vpn_site_link_id = azurerm_vpn_site.site.link[0].id
    shared_key       = var.shared_key
    protocol         = "IKEv2"
    bgp_enabled      = true

    ipsec_policy {
      dh_group                 = "DHGroup14"
      ike_encryption_algorithm = "AES256"
      ike_integrity_algorithm  = "SHA256"
      encryption_algorithm     = "AES256"
      integrity_algorithm      = "SHA256"
      pfs_group                = "PFS2048"
      sa_lifetime_sec          = 3600
      sa_data_size_kb          = 102400000
    }
  }
}