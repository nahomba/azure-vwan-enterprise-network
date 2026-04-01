output "vpn_site_id" {
  description = "VPN Site ID"
  value       = azurerm_vpn_site.site.id
}

output "connection_id" {
  description = "VPN Connection ID"
  value       = azurerm_vpn_gateway_connection.connection.id
}