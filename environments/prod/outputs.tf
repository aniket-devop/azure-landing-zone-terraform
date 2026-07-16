output "hub_resource_group" {
  value = azurerm_resource_group.hub.name
}

output "spoke_resource_group" {
  value = azurerm_resource_group.spoke.name
}

output "firewall_private_ip" {
  value = module.firewall.firewall_private_ip
}

output "key_vault_uri" {
  value = module.key_vault.key_vault_uri
}

output "aks_subnet_id" {
  value = module.spoke_network.aks_subnet_id
}
