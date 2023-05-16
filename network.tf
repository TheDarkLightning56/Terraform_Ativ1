resource "azurerm_virtual_network" "vnet-fit-cloud" {
  name                = "vnet-fit-cloud"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-fit-cloud.location
  resource_group_name = azurerm_resource_group.rg-fit-cloud.name
}


resource "azurerm_subnet" "sub-fit-cloud" {
  name                 = "sub-fit-cloud"
  resource_group_name  = azurerm_resource_group.rg-fit-cloud.name
  virtual_network_name = azurerm_virtual_network.vnet-fit-cloud.name
  address_prefixes    = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-fit-cloud" {
  name                = "nsg-fit-cloud"
  resource_group_name = azurerm_resource_group.rg-fit-cloud.name
  location            = azurerm_resource_group.rg-fit-cloud.location
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
