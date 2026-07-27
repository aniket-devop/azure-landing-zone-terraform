# Changelog

## [Unreleased]

### Added
- GitHub Actions CI: `terraform fmt -check`, `terraform init -backend=false`, `terraform validate` on PR and push to main.

### Not added yet (see open TODOs, not hidden)
- Security scanning (Checkov / Trivy) — deferred until the basic fmt/validate pipeline is confirmed green in real GitHub Actions runs.
- TFLint — same reason.
- terraform test coverage — module code needs to actually exist and match test assumptions first.
- Apply workflow — not building this until plan/validate is trustworthy.

## [0.1.0] - Initial version

### Added
- Hub-and-spoke network module structure (hub VNet, Firewall, Bastion)
- Spoke network module structure with NSG-bounded AKS subnet
- Key Vault module structure with RBAC authorization
- RBAC module structure scoped to resource group
- dev/prod environment folders

Note: "structure" here means folders/module skeletons exist per the original README description. I have not personally verified the resource blocks inside these modules — see open TODO to review actual `.tf` content.
