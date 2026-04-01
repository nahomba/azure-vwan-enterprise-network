output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.law.id
}

output "workspace_id" {
  description = "Log Analytics Workspace ID (alias)"
  value       = azurerm_log_analytics_workspace.law.id
}

output "action_group_id" {
  description = "Monitoring Action Group ID"
  value       = azurerm_monitor_action_group.main.id
}