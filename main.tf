# Terraform backend configuration for remote state file
terraform {
  backend "azurerm" {
    resource_group_name   = "opella-tfstate-rg"
    storage_account_name  = "opellatfstatedgs00112233" #tfstate713
    container_name        = "tfstate" #tfstate
    key                   = "terraform.tfstate"

  }
}

# defintion of the Azure provider version
provider "azurerm" {
  features {}
}

variable "foundation" {}

module "foundation" {
  source = "./modules"

  foundation = var.foundation

  providers = {
    azurerm.remote = azurerm
  }
}

output "test" {
  value = module.foundation
}
