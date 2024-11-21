provider "snowflake" {
  role = "SYSADMIN"
}

provider "airbyte" {
  // if running locally (Airbyte OSS), include the server url to the airbyte-api-server
  server_url = "http://localhost:8000/api/public/v1/"
  bearer_auth = local.airbyte_auth_api_key
}