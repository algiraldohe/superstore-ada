terraform {
  required_version = ">= 1.7.5"

  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "0.97.0"
    }
    airbyte = {
      source  = "airbytehq/airbyte"
      version = "0.6.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}