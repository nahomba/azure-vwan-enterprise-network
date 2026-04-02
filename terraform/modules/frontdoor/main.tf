# Azure Front Door Profile (PREMIUM)
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"
  tags                = var.tags
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.frontdoor_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  tags                     = var.tags
}

# Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "appgw-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    protocol            = "Https"
    interval_in_seconds = 100
    request_type        = "HEAD"
    path                = "/health"
  }
}

# Origin - Application Gateway East US (PRIVATE LINK)
resource "azurerm_cdn_frontdoor_origin" "appgw_eastus" {
  name                          = "appgw-eastus-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  enabled                        = true
  host_name                      = "placeholder" # required but ignored with Private Link
  origin_host_header             = "placeholder"
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true

  private_link {
    request_message        = "FrontDoor Private Access"
    location               = "eastus"
    private_link_target_id = var.appgw_eastus_id
  }
}

#  Origin - Application Gateway West EU (PRIVATE LINK)
resource "azurerm_cdn_frontdoor_origin" "appgw_westeu" {
  count = var.enable_westeu_origin ? 1 : 0

  name                          = "appgw-westeu-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  enabled                        = true
  host_name                      = "placeholder"
  origin_host_header             = "placeholder"
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true

  private_link {
    request_message        = "FrontDoor Private Access"
    location               = "westeurope"
    private_link_target_id = var.appgw_westeu_id
  }
}

# Route
resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  cdn_frontdoor_origin_ids = concat(
    [azurerm_cdn_frontdoor_origin.appgw_eastus.id],
    var.enable_westeu_origin ? [azurerm_cdn_frontdoor_origin.appgw_westeu[0].id] : []
  )

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

# WAF Policy
resource "azurerm_cdn_frontdoor_firewall_policy" "fd_waf" {
  name                = replace("${var.frontdoor_name}waf", "-", "")
  resource_group_name = var.resource_group_name
  sku_name            = azurerm_cdn_frontdoor_profile.fd.sku_name

  enabled = true
  mode    = "Prevention"

  custom_block_response_status_code = 403
  custom_block_response_body        = base64encode("Access Denied")

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }

  tags = var.tags
}

# Security Policy
resource "azurerm_cdn_frontdoor_security_policy" "fd_security" {
  name                     = "security-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.fd_waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}