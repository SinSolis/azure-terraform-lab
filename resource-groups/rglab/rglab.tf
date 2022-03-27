terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
    backend "azurerm" {
        resource_group_name  = "rglab"
        storage_account_name = "stlabylt3i"
        container_name       = "tfstate"
        key                  = "resource-groups/rglab/terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-lab" {
  name     = "rglab"
  location = "North Central US"
}