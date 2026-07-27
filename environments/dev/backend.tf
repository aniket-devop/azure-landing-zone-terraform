# Remote state. Create this storage account once, by hand or via a small
# bootstrap script, before running terraform init here -- it can't create
# the backend that stores its own state.
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "azurecloudtfstate01" # must be globally unique, change before use
    container_name       = "tfstate"
    key                  = "landing-zone-dev.tfstate"
  }
}
