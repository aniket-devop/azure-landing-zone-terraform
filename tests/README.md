# Tests

## 📝 TODO (Requires Me)

No tests exist yet. A native Terraform test (`terraform test`, Terraform >= 1.6) for the hub-network module was drafted earlier in this process, but it referenced resource names (`azurerm_virtual_network.hub`, etc.) that were guessed to match the README description — not confirmed against the real `main.tf`. That's exactly the kind of thing this repo is trying to stop doing, so it's been removed rather than left in place looking real.

Real next step: once `modules/hub-network/main.tf` actually exists with real resource names, write one test against the real resource names and confirm it runs with `terraform test` before claiming test coverage anywhere in this repo.
