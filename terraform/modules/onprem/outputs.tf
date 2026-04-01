output "vnet_id" {
  description = "The ID of the on-premises VNet"
  value       = azurerm_virtual_network.onprem.id
}

output "vnet_name" {
  description = "The name of the on-premises VNet"
  value       = azurerm_virtual_network.onprem.name
}

output "vpn_gateway_public_ip" {
  description = "Public IP of the VPN Gateway"
  value       = azurerm_public_ip.vpn_gateway_pip.ip_address
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.onprem_vpn.id
}

output "bgp_asn" {
  description = "BGP ASN of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.onprem_vpn.bgp_settings[0].asn
}

output "bgp_peering_address" {
  description = "BGP peering address of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.onprem_vpn.bgp_settings[0].peering_addresses[0].default_addresses[0]
}

output "workload_subnet_id" {
  description = "ID of the workload subnet"
  value       = azurerm_subnet.workload_subnet.id
}

output "vm_private_ip" {
  description = "Private IP of the test VM"
  value       = azurerm_network_interface.onprem_vm_nic.private_ip_address
}
