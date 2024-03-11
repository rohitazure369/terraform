terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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
  features {}
  use_msi = true
}
