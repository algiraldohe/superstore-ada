
module "snowflake" {
  source         = "./snowflake"
  database_name  = local.database_name
  warehouse_name = local.warehouse_name
  schema_name = var.snowflake_schema_name
}

module "airbyte" {
  source = "./airbyte"
  bucket_name = local.bucket_name
  region_name = local.region_name
  airbyte_service_role_arn = local.airbyte_service_role_arn
  airbyte_workspace_id = local.airbyte_workspace_id
  aws_profile = local.aws_profile
  snowflake_database_name = module.snowflake.snowflake_database_name
  snowflake_warehouse_name = module.snowflake.snowflake_warehouse_name
  snowflake_host = var.airbyte_snowflake_host
  snowflake_user = var.airbyte_snowflake_user
  snowflake_role = local.snowflake_role
  snowflake_schema_name = var.snowflake_schema_name
}