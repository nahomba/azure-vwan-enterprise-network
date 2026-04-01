output "vhub_id" {
  description = "Virtual Hub ID"
  value       = azurerm_virtual_hub.vhub.id
}

output "vhub_name" {
  description = "Virtual Hub Name"
  value       = azurerm_virtual_hub.vhub.name
}
