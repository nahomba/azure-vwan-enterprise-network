# ============================================================================
# APPLICATION GATEWAY MODULE (PRIVATE + FRONT DOOR READY)
# ============================================================================

resource "azurerm_application_gateway" "main" {
  #checkov:skip=CKV_AZURE_217:Temporary HTTP for bootstrap - will migrate to HTTPS via Key Vault
  #checkov:skip=CKV_AZURE_218:TLS will be enabled later using Key Vault certificates

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  # ============================================================================
  # NETWORK CONFIG
  # ============================================================================

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  # Keep HTTPS port for future (no breaking change later)
  frontend_port {
    name = "https-port"
    port = 443
  }

  # PRIVATE FRONTEND (NO PUBLIC IP)
  frontend_ip_configuration {
    name                          = "frontend-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  # ============================================================================
  # PRIVATE LINK (FOR FRONT DOOR)
  # ============================================================================

  private_link_configuration {
    name = "appgw-private-link"

    ip_configuration {
      name                          = "primary"
      subnet_id                     = var.subnet_id
      private_ip_address_allocation = "Dynamic"
      primary                       = true
    }
  }

  # ============================================================================
  # BACKEND
  # ============================================================================

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # ============================================================================
  # LISTENER (TEMP HTTP)
  # ============================================================================

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  # ============================================================================
  # ROUTING
  # ============================================================================

  request_routing_rule {
    name                       = "routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
  }

  # ============================================================================
  # WAF
  # ============================================================================

  waf_configuration {
    enabled                  = true
    firewall_mode            = "Prevention"
    rule_set_type            = "OWASP"
    rule_set_version         = "3.2"
    request_body_check       = true
    file_upload_limit_mb     = 100
    max_request_body_size_kb = 128
  }
}