resource "azurerm_resource_group" "hub" {
  name     = "rg-lz-hub-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke" {
  name     = "rg-lz-spoke-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "hub_network" {
  source = "../../modules/hub-network"

  resource_group_name           = azurerm_resource_group.hub.name
  location                      = var.location
  hub_vnet_name                 = "vnet-hub-${var.environment}"
  hub_address_space             = var.hub_address_space
  firewall_subnet_prefix        = var.firewall_subnet_prefix
  bastion_subnet_prefix         = var.bastion_subnet_prefix
  shared_services_subnet_prefix = var.shared_services_subnet_prefix
  tags                           = var.tags
}

module "spoke_network" {
  source = "../../modules/spoke-network"

  resource_group_name = azurerm_resource_group.spoke.name
  location             = var.location
  spoke_vnet_name      = "vnet-spoke-${var.environment}"
  spoke_address_space  = var.spoke_address_space
  aks_subnet_prefix    = var.aks_subnet_prefix
  tags                 = var.tags
}

module "peering" {
  source = "../../modules/peering"

  hub_resource_group_name   = azurerm_resource_group.hub.name
  spoke_resource_group_name = azurerm_resource_group.spoke.name
  hub_vnet_name              = module.hub_network.hub_vnet_name
  spoke_vnet_name            = module.spoke_network.spoke_vnet_name
  hub_vnet_id                = module.hub_network.hub_vnet_id
  spoke_vnet_id              = module.spoke_network.spoke_vnet_id
}

module "firewall" {
  source = "../../modules/firewall"

  resource_group_name = azurerm_resource_group.hub.name
  location             = var.location
  firewall_name        = "afw-lz-${var.environment}"
  firewall_subnet_id   = module.hub_network.firewall_subnet_id
  spoke_address_space  = var.spoke_address_space
  tags                 = var.tags
}

module "bastion" {
  source = "../../modules/bastion"

  resource_group_name = azurerm_resource_group.hub.name
  location             = var.location
  bastion_name         = "bas-lz-${var.environment}"
  bastion_subnet_id    = module.hub_network.bastion_subnet_id
  tags                 = var.tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  resource_group_name = azurerm_resource_group.spoke.name
  location             = var.location
  key_vault_name       = var.key_vault_name
  tenant_id            = data.azurerm_client_config.current.tenant_id
  allowed_subnet_ids   = [module.spoke_network.aks_subnet_id]
  tags                 = var.tags
}

module "rbac" {
  source = "../../modules/rbac"

  resource_group_id = azurerm_resource_group.spoke.id

  role_assignments = var.aks_identity_principal_id == "" ? {} : {
    aks_kv_access = {
      principal_id          = var.aks_identity_principal_id
      role_definition_name  = "Key Vault Secrets User"
    }
  }
}
