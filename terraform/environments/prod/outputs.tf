# ============================================================================
# PRODUCTION ENVIRONMENT OUTPUTS
# ============================================================================

# ============================================================================
# RESOURCE GROUP
# ============================================================================

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

# ============================================================================
# VIRTUAL WAN
# ============================================================================

output "vwan_id" {
  value = azurerm_virtual_wan.vwan.id
}

output "vwan_name" {
  value = azurerm_virtual_wan.vwan.name
}

# ============================================================================
# VIRTUAL HUBS
# ============================================================================

output "vhub_eastus_id" {
  value = module.vhub_eastus.vhub_id
}

output "vhub_westeu_id" {
  value = module.vhub_westeu.vhub_id
}

# ============================================================================
# FIREWALLS 
# ============================================================================

output "firewall_eastus_id" {
  value = module.firewall_eastus.firewall_id
}

output "firewall_westeu_id" {
  value = module.firewall_westeu.firewall_id
}

# ============================================================================
# SPOKE VNETS
# ============================================================================

output "spoke_eastus_vnet_id" {
  value = module.spoke_eastus.vnet_id
}

output "spoke_westeu_vnet_id" {
  value = module.spoke_westeu.vnet_id
}

# ============================================================================
# VIRTUAL MACHINES
# ============================================================================

output "vm_eastus_id" {
  value = module.vm_eastus.vm_id
}

output "vm_eastus_private_ip" {
  value = module.vm_eastus.private_ip
}

output "vm_westeu_id" {
  value = module.vm_westeu.vm_id
}

output "vm_westeu_private_ip" {
  value = module.vm_westeu.private_ip
}

# ============================================================================
# APPLICATION GATEWAYS
# ============================================================================

output "appgateway_eastus_id" {
  value = module.appgateway_eastus.id
}

output "appgateway_eastus_private_ip" {
  description = "Application Gateway East US Private IP"
  value       = module.appgateway_eastus.private_ip
}

output "appgateway_westeu_id" {
  value = module.appgateway_westeu.id
}

output "appgateway_westeu_private_ip" {
  description = "Application Gateway West Europe Private IP"
  value       = module.appgateway_westeu.private_ip
}

# ============================================================================
# MONITORING 
# ============================================================================

output "log_analytics_workspace_id" {
  value = module.monitoring.workspace_id
}

output "monitoring_action_group_id" {
  value = module.monitoring.action_group_id
}

# ============================================================================
# DEPLOYMENT SUMMARY
# ============================================================================

output "deployment_summary" {
  value = {
    environment  = var.environment
    regions      = ["East US", "West Europe"]
    hubs         = 2
    firewalls    = 2
    spokes       = 2
    vms          = 2
    app_gateways = 2
  }
}

# ============================================================================
# CONNECTIVITY INFO
# ============================================================================

output "connectivity_info" {
  value = {
    east_us = {
      hub_address      = var.vhub_eastus_address_prefix
      spoke_address    = var.spoke_eastus_address_space[0]
      vm_private_ip    = module.vm_eastus.private_ip
      appgw_private_ip = module.appgateway_eastus.private_ip
    }
    west_europe = {
      hub_address      = var.vhub_westeu_address_prefix
      spoke_address    = var.spoke_westeu_address_space[0]
      vm_private_ip    = module.vm_westeu.private_ip
      appgw_private_ip = module.appgateway_westeu.private_ip
    }
  }
}