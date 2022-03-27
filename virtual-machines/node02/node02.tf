# Inherit deployed subnet 
data "azurerm_subnet" "subnetid" {
  name                 = "labsubnet"
  virtual_network_name = "vnetlab"
  resource_group_name  = "rglab"
}

# Inherit deployed nsg
data "azurerm_network_security_group" "nsglabid" {
  name                = "nsglab"
  resource_group_name = "rglab"
}

# Create network interface
resource "azurerm_network_interface" "node02nic" {
  name                = "node02nic"
  location            = "Central US"
  resource_group_name = "rglab"

  ip_configuration {
    name                          = "node02nicconfig"
    subnet_id                     = data.azurerm_subnet.subnetid.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.node02nic.id
  network_security_group_id = data.azurerm_network_security_group.nsglabid.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "node02vm" {
  name                  = "node02"
  location              = "Central US"
  resource_group_name   = "rglab"
  network_interface_ids = [azurerm_network_interface.node02nic.id]
  size                  = "Standard_DS1"

  os_disk {
    name                 = "node02Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "node02"
  admin_username                  = "juan"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "juan"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}