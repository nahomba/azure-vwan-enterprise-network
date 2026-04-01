# -----------------------------
# OUTPUTS
# -----------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "vwan_id" {
  description = "Virtual WAN ID"
  value       = module.vwan.vwan_id
}

output "vhub_eastus_id" {
  description = "Virtual Hub East US ID"
  value       = module.vhub_eastus.vhub_id
}

output "firewall_eastus_id" {
  description = "Azure Firewall East US ID"
  value       = module.firewall_eastus.firewall_id
}

output "spoke_dev_vnet_id" {
  description = "Spoke Dev VNet ID"
  value       = module.spoke_dev.vnet_id
}

output "appgateway_dev_id" {
  description = "Application Gateway Dev ID"
  value       = module.appgateway_dev.id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.monitoring.log_analytics_workspace_id
}
