terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
    backend "azurerm" {
        resource_group_name  = "rglab"
        storage_account_name = "stlabyqspm"
        container_name       = "tfstate"
        key                  = "storage-accounts/stlab/terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}