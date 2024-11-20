resource "snowflake_warehouse" "warehouse" {
  name = local.warehouse_name
}

resource "snowflake_database" "db" {
  name       = local.database_name
  depends_on = [snowflake_warehouse.warehouse]
}