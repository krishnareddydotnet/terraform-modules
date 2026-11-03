# TFLint config used by CI. Run locally: tflint --init ; tflint --recursive --config "$(pwd)/.tflint.hcl"
config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Azure rules: invalid VM sizes, SKUs, deprecated arguments, and more.
plugin "azurerm" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# prevent_destroy cannot come from a variable, so a module cannot make it optional.
# Hard-coding it would block "terraform destroy" for every consumer (and every practice example).
# Protect data with soft delete, purge protection and resource locks in the env repo instead.
rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}

# Auto-heal rules depend on the app (slow requests, status codes), so the consumer sets them.
rule "azurerm_app_service_missing_auto_heal_setting" {
  enabled = false
}
