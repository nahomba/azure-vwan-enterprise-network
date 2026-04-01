# Routing Intent for Secured Hub
resource "azurerm_virtual_hub_routing_intent" "secured_hub" {
  name           = "routing-intent-secured"
  virtual_hub_id = var.virtual_hub_id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = var.firewall_id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = var.firewall_id
  }
}