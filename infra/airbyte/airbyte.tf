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
