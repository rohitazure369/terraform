terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  
}
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
    name = "RG-TF-DEMO"
    location = "Central India"
  
}


resource "azurerm_container_registry" "acr" {
  name                     = "acrrkdemonew"
  resource_group_name      = "RG-TF-DEMO"
  location                 = "Central India"
  sku                      = "Standard"
  admin_enabled            = true

  depends_on = [ azurerm_resource_group.rg ]
}

