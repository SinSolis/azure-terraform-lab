data "azurerm_subnet" "subnetid" {
  name                 = var.subnetname
  virtual_network_name = var.vnetname
  resource_group_name  = var.rgnetwork
}

resource "azurerm_network_interface" "nic-1" {
  name                = "${var.vmname}-nic-1"
  location            = var.location
  resource_group_name = var.rgname
  tags = {
    env = "lab"
  }

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.subnetid.id
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.vmname
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vmsize
  admin_username      = "juan"
  network_interface_ids = [
    azurerm_network_interface.nic-1.id, 
  ]

  admin_ssh_key {
      username   = "juan"
      public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = var.osdiskcaching
    storage_account_type = var.osdiskstoragetype
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.image_sku
    version   = "latest"
  }
   
  tags = merge({"terraform"="true"} , var.tag)
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}