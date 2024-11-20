terraform {
  required_version = ">= 1.7.5"

  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "0.97.0"
    }
  }
}