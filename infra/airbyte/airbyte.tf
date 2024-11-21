// Airbyte Terraform provider documentation: https://registry.terraform.io/providers/airbytehq/airbyte/latest/docs

// Sources
resource "airbyte_source_s3" "superstore-ada-datasets" {
    configuration = {
      bucket = var.bucket_name
      region_name = var.region_name
      role_arn = var.airbyte_service_role_arn
      profile = var.aws_profile

      streams = [ {
        days_to_sync_if_history_is_full = 1
        format = {
            csv_format = {
                delimiter = ","
            }
            }
        globs = ["superstore-dataset/datasets/*.csv"]
        name = "overall-superstore"
      } ]
    }

    name = "S3 Superstore"
    workspace_id = var.airbyte_workspace_id
    
}


// Destinations

// AWS Secrets implementation for Terraform
// Private Key
data "aws_secretsmanager_secret" "snowflake_tf_snow_private_key" {
  name = "snowflake_tf_snow_private_key"
}

data "aws_secretsmanager_secret_version" "snowflake_tf_snow_private_key" {
  secret_id = data.aws_secretsmanager_secret.snowflake_tf_snow_private_key.id
}


resource "airbyte_destination_snowflake" "superstore-ada-datasets" {
    configuration = {
      credentials = {
        key_pair_authentication = {
          private_key = jsondecode(data.aws_secretsmanager_secret_version.snowflake_tf_snow_private_key.secret_string)["SNOWFLAKE_PRIVATE_KEY"]
        }
      }
      database = var.snowflake_database_name
      host = var.snowflake_host
      role = var.snowflake_role 
      schema = var.snowflake_schema_name
      username = var.snowflake_user
      warehouse = var.snowflake_warehouse_name
    }

    name = "Snowflake Superstore"
    workspace_id = var.airbyte_workspace_id

}
