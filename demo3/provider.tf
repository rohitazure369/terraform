terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13"
    }
  }

  backend "azurerm" {

  }
}

provider "azurerm" {
  skip_provider_registration = true 
  features {}
  use_msi = true
}
