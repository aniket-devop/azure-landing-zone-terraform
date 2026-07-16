terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "azurecloudtfstate01" # same storage account, different key below
    container_name       = "tfstate"
    key                  = "landing-zone-prod.tfstate"
  }
}
