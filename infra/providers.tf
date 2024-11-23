provider "snowflake" {
  role = "ACCOUNTADMIN"
}

provider "aws" {
  profile = local.aws_profile
}

// AWS Secrets implementation for Terraform
data "aws_secretsmanager_secret" "airbyte_access_token" {
  name = "airbyte-access-token"
}

data "aws_secretsmanager_secret_version" "airbyte_access_token" {
  secret_id = data.aws_secretsmanager_secret.airbyte_access_token.id
}

provider "airbyte" {
  // Airbyte cloud implementation
  # client_id = "87f9ce1d-0dd3-4576-a171-0b02fc954333"
  # client_secret = "gcRWxqQ4DHLVgPGkVstCXhZRphZGNuMs"

  // if running locally (Airbyte OSS), include the server url to the airbyte-api-server
  server_url  = "http://localhost:8000/api/public/v1/"
  bearer_auth = jsondecode(data.aws_secretsmanager_secret_version.airbyte_access_token.secret_string)["airbyte_access_token"]

}