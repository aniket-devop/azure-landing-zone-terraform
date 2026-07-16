variable "resource_group_name" {
  description = "Resource group for the spoke network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "spoke_address_space" {
  description = "Address space for the spoke VNet, e.g. [\"10.1.0.0/16\"]"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "CIDR for the AKS subnet"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
