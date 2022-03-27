# Create public IPs
resource "azurerm_public_ip" "controllerpublicip" {
  name                = "controllerPublicIP"
  location            = "Central US"
  resource_group_name = "rglab"
  allocation_method   = "Static"
}

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
resource "azurerm_network_interface" "controllernic" {
  name                = "controllernic"
  location            = "Central US"
  resource_group_name = "rglab"

  ip_configuration {
    name                          = "controllernicconfig"
    subnet_id                     = data.azurerm_subnet.subnetid.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.controllerpublicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.controllernic.id
  network_security_group_id = data.azurerm_network_security_group.nsglabid.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "controllervm" {
  name                  = "controller"
  location              = "Central US"
  resource_group_name   = "rglab"
  network_interface_ids = [azurerm_network_interface.controllernic.id]
  size                  = "Standard_DS1"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "controller"
  admin_username                  = "juan"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "juan"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}