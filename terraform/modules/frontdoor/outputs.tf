output "frontdoor_id" {
  description = "ID of the Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.fd.id
}

output "frontdoor_endpoint_url" {
  description = "Front Door endpoint URL"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name}"
}

output "frontdoor_endpoint_id" {
  description = "ID of the Front Door endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
}

output "waf_policy_id" {
  description = "ID of the WAF policy"
  value       = azurerm_cdn_frontdoor_firewall_policy.fd_waf.id
}