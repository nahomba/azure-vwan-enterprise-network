output "id" {
  description = "Application Gateway ID"
  value       = azurerm_application_gateway.main.id
}

output "name" {
  description = "Application Gateway name"
  value       = azurerm_application_gateway.main.name
}

output "private_ip" {
  description = "Application Gateway private IP"
  value       = azurerm_application_gateway.main.frontend_ip_configuration[0].private_ip_address
}