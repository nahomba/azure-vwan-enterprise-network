resource "azurerm_route_table" "rt" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = !var.disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_route" "routes" {
  for_each = var.routes

  name                   = each.key
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  count = var.subnet_id != null ? 1 : 0

  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.rt.id
}
