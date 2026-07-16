variable "resource_group_id" {
  description = "Scope the role assignment to this resource group only -- never the subscription"
  type        = string
}

variable "role_assignments" {
  description = "Map of role assignments: key is a friendly name, value has principal_id and role_definition_name"
  type = map(object({
    principal_id         = string
    role_definition_name = string
  }))
  default = {}
}
