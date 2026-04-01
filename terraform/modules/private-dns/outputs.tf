output "dns_zone_id" {
  description = "DNS zone ID"
  value       = azurerm_private_dns_zone.zone.id
}

output "dns_zone_name" {
  description = "DNS zone name"
  value       = azurerm_private_dns_zone.zone.name
}