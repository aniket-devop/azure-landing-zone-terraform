resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"
  tags                = var.tags

  # RBAC instead of legacy access policies -- keeps permissions in one place
  # (Entra ID role assignments) instead of two separate permission models.
  enable_rbac_authorization = true

  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }
}
