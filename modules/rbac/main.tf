# Every assignment here is scoped to the resource group passed in, not the
# subscription. One broad Owner/Contributor role at the subscription level
# is exactly what this module is written to avoid.
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                = var.resource_group_id
  role_definition_name = each.value.role_definition_name
  principal_id          = each.value.principal_id
}
