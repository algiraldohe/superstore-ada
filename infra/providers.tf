provider "snowflake" {
  role = "ACCOUNTADMIN"
}

provider "aws" {
  profile = local.aws_profile
}

// AWS Secrets implementation for Terraform
data "aws_secretsmanager_secret" "airbyte-access-token" {
  name = "airbyte-access-token"
}

data "aws_secretsmanager_secret_version" "airbyte-access-token" {
  secret_id = data.aws_secretsmanager_secret.airbyte-access-token.id
}

provider "airbyte" {
  // if running locally (Airbyte OSS), include the server url to the airbyte-api-server
  server_url  = "http://localhost:8000/api/public/v1/"
  bearer_auth = jsondecode(data.aws_secretsmanager_secret_version.airbyte-access-token.secret_string)["airbyte_access_token"]

}