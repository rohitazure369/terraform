resource "azurerm_virtual_network" "aks" {
  name                = "vnet-aks-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = var.env
  }
}


resource "azurerm_subnet" "vm" {
  name                 = "snet-vm"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.4.0/22"]

}