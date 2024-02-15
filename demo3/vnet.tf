resource "azurerm_virtual_network" "example" {
  name                = "vnet-aks-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "snet-vm"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "snet-aks"
    address_prefix = "10.0.4.0/22"
  }

  tags = {
    environment = var.env
  }
}