resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Standard"
  tags                = var.tags
}