# Applying this pattern to every module

`hub-network/` now has `variables.tf`, `outputs.tf`, and `versions.tf` as a reference implementation.

Do the same for `spoke-network`, `peering`, `firewall`, `bastion`, `key-vault`, and `rbac` before your next commit:

1. Move every `variable` block out of `main.tf` into that module's own `variables.tf`, with a `description` and `type` on every single one — no exceptions, TFLint's `terraform_documented_variables` rule will fail the build otherwise.
2. Move every `output` block into `outputs.tf`. Only output what another module or environment actually references — don't output everything "just in case."
3. Add a `versions.tf` pinning `required_version` and `required_providers` — copy `hub-network/versions.tf` and adjust if a module needs a different provider (e.g. `key-vault` may also need the `random` provider if you generate suffixes).
4. Delete this file once all seven modules follow the pattern.
