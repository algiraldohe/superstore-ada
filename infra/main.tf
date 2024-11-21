module "snowflake" {
  source         = "./snowflake"
  database_name  = local.database_name
  warehouse_name = local.warehouse_name
}

module "airbyte" {
  source                   = "./airbyte"
  bucket_name              = local.bucket_name
  region_name              = local.region_name
  airbyte_service_role_arn = local.airbyte_service_role_arn
  airbyte_workspace_id     = local.airbyte_workspace_id
  aws_profile              = local.aws_profile
}