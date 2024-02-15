resource "azurerm_container_registry" "acr" {
  name                     = "acrrkdemonew"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  sku                      = "Standard"
  admin_enabled            = true

}