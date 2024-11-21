locals {
  prefix                   = upper("tf")
  warehouse_name           = "${local.prefix}_${upper("compute_wh")}_${upper(terraform.workspace)}"
  database_name            = "${local.prefix}_${upper("daverse")}_${upper(terraform.workspace)}"
  bucket_name              = "superstore-dataset"
  region_name              = "us-east-1"
  airbyte_service_role_arn = "arn:aws:iam::992382719587:role/airbyte-service-access-s3"
  airbyte_workspace_id     = "993c8966-4593-4478-9f4b-07424e8e407d"
  aws_profile              = "daverse-${terraform.workspace}"
  snowflake_role = upper("accountadmin")

}