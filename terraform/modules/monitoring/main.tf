# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.workspace_name}"
  resource_group_name = var.resource_group_name
  short_name          = "vwanalerts"
  tags                = var.tags

  email_receiver {
    name          = "sendtoadmin"
    email_address = var.alert_email
  }
}