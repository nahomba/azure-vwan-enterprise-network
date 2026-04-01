output "subnet_ids" {
  description = "Map of subnet names to IDs"

  value = {
    for subnet in azurerm_subnet.spoke :
    subnet.name => subnet.id
  }
}

output "vnet_id" {
  description = "VNet ID"

  value = azurerm_virtual_network.spoke.id
}