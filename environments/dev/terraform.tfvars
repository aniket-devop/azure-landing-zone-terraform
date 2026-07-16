environment = "dev"
location    = "centralindia"

hub_address_space   = ["10.0.0.0/16"]
spoke_address_space = ["10.1.0.0/16"]

firewall_subnet_prefix        = "10.0.0.0/26"
bastion_subnet_prefix         = "10.0.1.0/26"
shared_services_subnet_prefix = "10.0.2.0/24"
aks_subnet_prefix             = "10.1.0.0/22"

# Change this -- Key Vault names are globally unique across all of Azure
key_vault_name = "kv-ani"

tags = {
  project     = "azure-landing-zone"
  environment = "dev"
  managed_by  = "terraform"
}
