output "vpn_site_id" {
  description = "ID of the VPN site"
  value       = azurerm_vpn_site.onprem.id
}

output "vpn_connection_id" {
  description = "ID of the VPN connection"
  value       = azurerm_vpn_gateway_connection.hub_to_onprem.id
}

output "connection_name" {
  description = "Name of the VPN connection"
  value       = azurerm_vpn_gateway_connection.hub_to_onprem.name
}