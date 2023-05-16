resource "azurerm_public_ip" "ip-fit-cloud" {
  name                = "ip-fit-cloud"
  location            = azurerm_resource_group.rg-fit-cloud.location
  resource_group_name = azurerm_resource_group.rg-fit-cloud.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic-fit-cloud" {
  name                = "nic-fit-cloud"
  location            = azurerm_resource_group.rg-fit-cloud.location
  resource_group_name = azurerm_resource_group.rg-fit-cloud.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-fit-cloud.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip-fit-cloud.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-fit-cloud" {
  name                = "vm-fit-cloud"
  resource_group_name = azurerm_resource_group.rg-fit-cloud.name
  location            = azurerm_resource_group.rg-fit-cloud.location
  size                = "Standart_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "atividade1@"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-fit-cloud.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource  "azurerm_network_interface_security_group_association" "nic-nsg-fit-cloud" {
  network_interface_id = azurerm_network_interface.nic-fit-cloud.id
  network_security_group_id = azurerm_network_security_group.nsg-fit-cloud.id
  
}

resource "null_resource" "install-nginx" {
  connection {
    type = "ssh"
    host = azurerm_public_ip.ip-fit-cloud.ip_address
    user = "adminuser"
    password = "Atividade1"
  }
  
  provisioner "remote-exec" {
  inline = [ 
    "sudo apt update",
    "sudo apt install -y nginx"
   ]
  }

  depends_on = [ 
    azurerm_linux_virtual_machine.vm-fit-cloud
   ]

}


  






