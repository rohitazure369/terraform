resource "azurerm_network_interface" "vm" {
  name                = "vm-bastion-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-aks-bastion"
  location            = var.rg_location
  resource_group_name = var.rg_name
  size                = "Standard_F2"
  admin_username      = "adminuser"
  disable_password_authentication = false  # Disabling password authentication

  admin_password      = "AzureAdminConsole100!"
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}