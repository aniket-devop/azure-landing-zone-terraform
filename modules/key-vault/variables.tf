variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "key_vault_name" {
  description = "Must be globally unique across Azure"
  type        = string
}

variable "tenant_id" {
  type = string
}

variable "allowed_subnet_ids" {
  description = "Subnets allowed through the Key Vault firewall (defense in depth alongside RBAC)"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
