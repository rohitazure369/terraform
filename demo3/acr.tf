resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  sku                      = "Standard"
  admin_enabled            = true

}