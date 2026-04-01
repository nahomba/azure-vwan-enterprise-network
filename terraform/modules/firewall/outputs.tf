output "firewall_id" {
  description = "Azure Firewall ID"
  value       = azurerm_firewall.fw.id
}

output "firewall_name" {
  description = "Azure Firewall Name"
  value       = azurerm_firewall.fw.name
}
