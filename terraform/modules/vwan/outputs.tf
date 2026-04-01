output "vwan_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.vwan.id
}

output "vwan_name" {
  description = "Virtual WAN Name"
  value       = azurerm_virtual_wan.vwan.name
}
