# Azure Landing Zone in Terraform

![Terraform CI](https://github.com/aniket-devop/azure-landing-zone-terraform/actions/workflows/terraform-ci.yml/badge.svg)

A hub-and-spoke Azure landing zone in Terraform: hub VNet with Azure Firewall and Bastion, a spoke VNet with an NSG-bounded subnet for AKS, RBAC-authorized Key Vault, and role assignments scoped to the resource group rather than the subscription.

Personal sandbox project, sized for one person to run and re-run — not production infrastructure serving real traffic.

📄 [Architecture, diagrams, and known limitations →](docs/architecture.md)

## Structure

```
azure-landing-zone-terraform/
├── .github/workflows/
│   └── terraform-ci.yml       # fmt -check, init, validate — that's all it does right now
├── modules/
│   ├── hub-network/            # variables.tf / outputs.tf / versions.tf are templates — main.tf TODO
│   ├── spoke-network/
│   ├── peering/
│   ├── firewall/
│   ├── bastion/
│   ├── key-vault/
│   └── rbac/
├── environments/
│   ├── dev/
│   └── prod/
├── tests/                       # currently empty, see tests/README.md
├── docs/
│   ├── architecture.md
│   └── screenshots/             # currently empty, see docs/screenshots/README.md for what to capture
├── CHANGELOG.md
└── LICENSE
```

## Prerequisites

- Terraform >= 1.7
- An Azure subscription, `az login` done (or service principal env vars set)
- A storage account + container for remote state, created once by hand:

```bash
az group create -n rg-tfstate -l centralindia
az storage account create -n sttfstatelandingzone -g rg-tfstate -l centralindia --sku Standard_LRS
az storage container create -n tfstate --account-name sttfstatelandingzone
```

## Usage

```bash
cd environments/dev
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## CI

Current pipeline (`.github/workflows/terraform-ci.yml`) runs on every PR and push to main:
1. `terraform fmt -check -recursive`
2. `terraform init -backend=false` (dev environment)
3. `terraform validate` (dev environment)

That's it. No security scanning, no automated plan, no apply automation yet — see [CHANGELOG.md](CHANGELOG.md) for what's planned versus what's actually built.

## Testing

No tests exist yet. See [tests/README.md](tests/README.md).

## Screenshots

No screenshots exist yet. See [docs/screenshots/README.md](docs/screenshots/README.md) for exactly what to capture.

## What this doesn't do yet

- No security scanning in CI
- No apply automation
- No test coverage
- No private endpoint on Key Vault (network ACL + RBAC is the boundary here)
- Only manually-run `terraform plan` / `apply` / `destroy` against a real subscription so far — no load testing

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE)
