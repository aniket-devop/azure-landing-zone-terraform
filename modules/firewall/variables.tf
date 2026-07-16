variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_name" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "spoke_address_space" {
  description = "Spoke CIDR(s) allowed to egress through the firewall"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
