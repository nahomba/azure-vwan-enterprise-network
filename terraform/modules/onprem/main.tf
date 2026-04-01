# On-premises VNet
resource "azurerm_virtual_network" "onprem" {
  name                = var.onprem_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# Gateway Subnet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = [var.gateway_subnet]
}

# Workload Subnet
resource "azurerm_subnet" "workload_subnet" {
  name                 = "workload-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 1)]
}

# Public IP for VPN Gateway
resource "azurerm_public_ip" "vpn_gateway_pip" {
  name                = "${var.vpn_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# VPN Gateway (On-premises simulation)
resource "azurerm_virtual_network_gateway" "onprem_vpn" {
  name                = var.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  bgp_enabled         = true
  sku                 = "VpnGw1"
  generation          = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  bgp_settings {
    asn = var.bgp_asn
  }

  tags = var.tags
}

# Network Interface for test VM
resource "azurerm_network_interface" "onprem_vm_nic" {
  name                = "${var.onprem_vnet_name}-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.workload_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Test VM (Linux)
resource "azurerm_linux_virtual_machine" "onprem_vm" {
  name                            = "${var.onprem_vnet_name}-vm"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.onprem_vm_nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

# Network Security Group for workload subnet
resource "azurerm_network_security_group" "workload_nsg" {
  name                = "${var.onprem_vnet_name}-workload-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.address_space[0]
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with workload subnet
resource "azurerm_subnet_network_security_group_association" "workload_nsg_association" {
  subnet_id                 = azurerm_subnet.workload_subnet.id
  network_security_group_id = azurerm_network_security_group.workload_nsg.id
}
