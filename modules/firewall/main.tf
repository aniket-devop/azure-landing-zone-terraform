resource "azurerm_public_ip" "firewall" {
  name                = "pip-${var.firewall_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "afwp-${var.firewall_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "this" {
  name                = var.firewall_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Deny-by-default network rule collection. Only explicit egress below is allowed;
# everything else from the spoke gets dropped at the firewall.
resource "azurerm_firewall_policy_rule_collection_group" "spoke_egress" {
  name               = "rcg-spoke-egress"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 200

  network_rule_collection {
    name     = "allow-dns-and-https-egress"
    priority = 210
    action   = "Allow"

    rule {
      name                  = "allow-https-out"
      protocols             = ["TCP"]
      source_addresses      = var.spoke_address_space
      destination_addresses = ["*"]
      destination_ports     = ["443"]
    }

    rule {
      name                  = "allow-dns-out"
      protocols             = ["UDP"]
      source_addresses      = var.spoke_address_space
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }
  }
}
