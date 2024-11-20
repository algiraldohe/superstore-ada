module "snowflake" {
  source         = "./snowflake"
  database_name  = local.database_name
  warehouse_name = local.warehouse_name
}

module "airbyte" {
  source = "./airbyte"
}