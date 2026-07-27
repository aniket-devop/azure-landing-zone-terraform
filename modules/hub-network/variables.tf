# TEMPLATE — adapt to your actual hub-network module.
# Convention applied consistently across every module in this repo:
#   variables.tf  -> all inputs, every one documented, typed, and validated where sensible
#   main.tf       -> resources only
#   outputs.tf    -> only what other modules/environments actually consume
#   versions.tf   -> pinned provider + terraform version constraints

variable "resource_group_name" {
  description = "Name of the resource group the hub network is deployed into."
  type        = string
}

variable "location" {
  description = "Azure region for the hub network resources."
  type        = string
  default     = "centralindia"
}

variable "hub_vnet_address_space" {
  description = "Address space for the hub VNet, e.g. [\"10.0.0.0/16\"]."
  type        = list(string)

  validation {
    condition     = length(var.hub_vnet_address_space) > 0
    error_message = "hub_vnet_address_space must contain at least one CIDR block."
  }
}

variable "firewall_subnet_prefix" {
  description = "CIDR for AzureFirewallSubnet. Must be named exactly 'AzureFirewallSubnet' at the subnet resource level — Azure requires this literal name."
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "CIDR for AzureBastionSubnet. Must be named exactly 'AzureBastionSubnet' — Azure requires this literal name and a minimum /26."
  type        = string
}

variable "tags" {
  description = "Common tags applied to every resource in this module."
  type        = map(string)
  default     = {}
}
