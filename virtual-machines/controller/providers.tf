terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
    backend "azurerm" {
        resource_group_name  = "rglab"
        storage_account_name = "stlabyqspm"
        container_name       = "tfstate"
        key                  = "virtual-machines/controller/terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}