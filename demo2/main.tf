terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "RG-TF-DEMO"
    storage_account_name = "rktfstatesa2024"
    container_name       = "terraform"
    key                  = "dev.tfstate"
  }
  }
  

provider "azurerm" {
  features {}
  use_msi = true
}



resource "azurerm_container_registry" "acr" {
  name                     = "acrrkdemonew"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  sku                      = "Standard"
  admin_enabled            = true

}


resource "azurerm_service_plan" "app_service_plan" {
  name                = "rkazurewebappnew-plan"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  os_type             = "Linux"
  sku_name            = "S1"

}

resource "azurerm_linux_web_app" "web_app" {
  name                = "rkazurewebappnew"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  service_plan_id = azurerm_service_plan.app_service_plan.id


  site_config {
    always_on        = "true"
  }


  app_settings =  {

    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password

  }


  identity {
    type = "SystemAssigned"
  }

}


resource "azurerm_linux_web_app_slot" "web_app_slot_dev" {
  name           = "rkazurewebappnew-dev"
  app_service_id = azurerm_linux_web_app.web_app.id

   site_config {
    always_on        = "true"
  }


  app_settings =  {

    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password

  }

}