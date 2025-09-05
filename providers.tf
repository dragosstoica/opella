terraform {
  required_version = ">= 1.13.1"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 4.42.0"
    }
  }
}

data "azurerm_client_config" "current" {}