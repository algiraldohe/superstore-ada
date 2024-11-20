// Airbyte Terraform provider documentation: https://registry.terraform.io/providers/airbytehq/airbyte/latest/docs

terraform {
  required_version = ">= 1.7.5"

  required_providers {
    airbyte = {
        source = "airbytehq/airbyte"
        version = "0.6.5"
    }
  }
}