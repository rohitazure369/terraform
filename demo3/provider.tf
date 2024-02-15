terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13"
    }
  }

  backend "azurerm" {

  }
  

provider "azurerm" {
  features {}
  use_msi = true
}
