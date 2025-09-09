# Terraform backend configuration for remote state file
terraform {
  backend "azurerm" {
    resource_group_name   = "opella-tfstate-rg"
    storage_account_name  = "opellatfstatedgs00112233" #tfstate713
    container_name        = "tfstate" #tfstate
    key                   = "terraform.tfstate"

  }
}

variable "environment" {
  description = "Deployment environment (dev, test, prod, etc.)"
  type = string 
  default = "dev"
}

# defintion of the Azure provider version
provider "azurerm" {
  features {}
}

locals {
  raw_yaml = yamldecode(file("${path.module}/variable.auto.tfvars.yaml"))
  foundation_map = local.raw_yaml.foundation
}

module "foundation" {
  source = "./modules"

  foundation = local.foundation_map

  providers = {
    azurerm.remote = azurerm
  }
}

output "test" {
  value = module.foundation
}
