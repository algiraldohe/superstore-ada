locals {
  prefix                   = "tf"
  project_name             = "superstore"
  warehouse_name           = "${upper(local.prefix)}_${upper("compute_wh")}_${upper(terraform.workspace)}"
  database_name            = "${upper(local.prefix)}_${upper("daverse")}_${upper(terraform.workspace)}"
  schema_name              = "${upper(local.prefix)}_${var.snowflake_schema_name}_${upper(terraform.workspace)}"
  bucket_name              = "superstore-dataset"
  region_name              = "us-east-1"
  airbyte_service_role_arn = "arn:aws:iam::992382719587:role/airbyte-service-access-s3"
  airbyte_workspace_id     = "be15439c-0e42-4173-a353-74f54852e242" //"993c8966-4593-4478-9f4b-07424e8e407d"
  airbyte_prefix           = "${local.prefix}_"
  aws_profile              = "daverse-${terraform.workspace}"
  snowflake_role           = upper("accountadmin")

}