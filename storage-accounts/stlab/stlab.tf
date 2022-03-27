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
        key                  = "storage-accounts/stlab/terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "stlab" {
  name                     = "stlab${random_string.resource_code.result}"
  resource_group_name      = "rglab"
  location                 = "North Central US"
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  shared_access_key_enabled = "true"
  min_tls_version = "TLS1_2"

  tags = {
    env = "lab"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.stlab.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.stlab]
}