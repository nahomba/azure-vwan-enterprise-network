output "private_endpoint_id" {
  description = "Private endpoint ID"
  value       = azurerm_private_endpoint.pe.id
}

output "private_endpoint_name" {
  description = "Private endpoint name"
  value       = azurerm_private_endpoint.pe.name
}

output "private_ip_address" {
  description = "Private IP address"
  value       = try(data.azurerm_private_endpoint_connection.pe_connection.private_service_connection[0].private_ip_address, null)
}

output "network_interface_id" {
  description = "Network interface ID"
  value       = azurerm_private_endpoint.pe.network_interface[0].id
}