variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "hub_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "spoke_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "firewall_subnet_prefix" {
  type    = string
  default = "10.0.0.0/26"
}

variable "bastion_subnet_prefix" {
  type    = string
  default = "10.0.1.0/26"
}

variable "shared_services_subnet_prefix" {
  type    = string
  default = "10.0.2.0/24"
}

variable "aks_subnet_prefix" {
  type    = string
  default = "10.1.0.0/22"
}

variable "key_vault_name" {
  description = "Must be globally unique across Azure -- change before applying"
  type        = string
  default     = "kv-lz-dev-changeme"
}

variable "aks_identity_principal_id" {
  description = "Object ID of the managed identity / SP that should get scoped access to this resource group. Leave blank to skip."
  type        = string
  default     = ""
}

variable "tags" {
  type = map(string)
  default = {
    project     = "azure-landing-zone"
    environment = "dev"
    managed_by  = "terraform"
  }
}
