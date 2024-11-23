// Airbyte Terraform provider documentation: https://registry.terraform.io/providers/airbytehq/airbyte/latest/docs

// AWS Secrets implementation for Terraform
// Snowflake Private Key
# data "aws_secretsmanager_secret" "snowflake_tf_snow_private_key" {
#   name = "snowflake_tf_snow_private_key"
# }

# data "aws_secretsmanager_secret_version" "snowflake_tf_snow_private_key" {
#   secret_id = data.aws_secretsmanager_secret.snowflake_tf_snow_private_key.id
# }

// Snowflake 
data "aws_secretsmanager_secret" "airbyte_user_password" {
  name = "airbyte-access-token"
}

data "aws_secretsmanager_secret_version" "airbyte_user_password" {
  secret_id = "airbyte-access-token"
}

// AWS Access Keys
data "aws_secretsmanager_secret" "airbyte_aws_access_key_id" {
  name = "airbyte-access-token"
}

data "aws_secretsmanager_secret_version" "airbyte_aws_access_key_id" {
  secret_id = data.aws_secretsmanager_secret.airbyte_aws_access_key_id.id
}

data "aws_secretsmanager_secret" "airbyte_aws_secret_access_key" {
  name = "airbyte-access-token"
}

data "aws_secretsmanager_secret_version" "airbyte_aws_secret_access_key" {
  secret_id = data.aws_secretsmanager_secret.airbyte_aws_secret_access_key.id
}


// Sources
resource "airbyte_source_s3" "superstore_ada_datasets" {
  configuration = {
    bucket                = var.bucket_name
    region_name           = var.region_name
    aws_access_key_id     = jsondecode(data.aws_secretsmanager_secret_version.airbyte_aws_access_key_id.secret_string)["airbyte_aws_access_key_id"]
    aws_secret_access_key = jsondecode(data.aws_secretsmanager_secret_version.airbyte_aws_secret_access_key.secret_string)["airbyte_aws_secret_access_key"]
    profile               = var.aws_profile

    streams = [{
      days_to_sync_if_history_is_full = 1
      format = {
        csv_format = {
          delimiter = ","
        }
      }
      globs = ["datasets/*.csv"]
      name  = "overall-superstore"
    }]
  }

  name         = "s3-${var.project_name}"
  workspace_id = var.airbyte_workspace_id

}

// Destinations
resource "airbyte_destination_snowflake" "superstore_ada_datasets" {
  configuration = {
    credentials = {
      username_and_password = {
        password = jsondecode(data.aws_secretsmanager_secret_version.airbyte_user_password.secret_string)["airbyte_user_password"]
      }
    }
    database  = var.snowflake_database_name
    host      = var.snowflake_host
    role      = var.snowflake_role
    schema    = var.snowflake_schema_name
    username  = var.snowflake_user
    warehouse = var.snowflake_warehouse_name
  }

  name         = "snowflake-${var.project_name}"
  workspace_id = var.airbyte_workspace_id

}

// Connections
resource "airbyte_connection" "s3_to_snowflake_superstore_ada_datasets" {
  schedule = {
    schedule_type = "manual"
  }
  destination_id = airbyte_destination_snowflake.superstore_ada_datasets.destination_id
  source_id      = airbyte_source_s3.superstore_ada_datasets.source_id
  name           = "s3-to-snowflake-${var.project_name}"
  prefix         = var.prefix
}