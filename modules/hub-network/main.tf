resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.hub_address_space
  tags                = var.tags
}

# Name is fixed by Azure -- AzureFirewallSubnet will not work as any other name.
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

# Name is fixed by Azure -- AzureBastionSubnet will not work as any other name.
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_subnet" "shared_services" {
  name                 = "snet-shared-services"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.shared_services_subnet_prefix]
}
