resource "azurerm_private_endpoint" "pe" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.private_endpoint_name}-connection"
    private_connection_resource_id = var.target_resource_id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
    request_message                = var.is_manual_connection ? var.request_message : null
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_ids != null ? [1] : []
    content {
      name                 = "${var.private_endpoint_name}-dns-group"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}

# Get Private Endpoint IP
data "azurerm_private_endpoint_connection" "pe_connection" {
  name                = azurerm_private_endpoint.pe.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_private_endpoint.pe]
}