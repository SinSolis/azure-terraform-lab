resource "azurerm_network_security_group" "nsglab" {
  name                = "nsglab"
  location            = "Central US"
  resource_group_name = "rglab"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnetlab" {
  name                = "vnetlab"
  location            = "Central US"
  resource_group_name = "rglab"
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "labsubnet"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    env = "lab"
  }
}