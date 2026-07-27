output "hub_vnet_id" {
  description = "Resource ID of the hub VNet, consumed by the peering module."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet."
  value       = azurerm_virtual_network.hub.name
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall, used by spoke route tables to force egress through it."
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}
