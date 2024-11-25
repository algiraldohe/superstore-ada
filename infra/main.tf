
module "snowflake" {
  source         = "./snowflake"
  database_name  = local.database_name
  warehouse_name = local.warehouse_name
  schema_name    = local.schema_name
}

module "airbyte" {
  //General
  source       = "./airbyte"
  project_name = local.project_name
  bucket_name  = local.bucket_name
  region_name  = local.region_name
  airbyte_prefix = local.airbyte_prefix

  // Source Required
  airbyte_service_role_arn = local.airbyte_service_role_arn
  airbyte_workspace_id     = local.airbyte_workspace_id
  aws_profile              = local.aws_profile

  // Destination Required
  snowflake_database_name  = module.snowflake.snowflake_database_name  //Output
  snowflake_warehouse_name = module.snowflake.snowflake_warehouse_name // Output
  snowflake_host           = var.airbyte_snowflake_host
  snowflake_user           = var.airbyte_snowflake_user
  snowflake_role           = local.snowflake_role
  snowflake_schema_name    = local.schema_name
}