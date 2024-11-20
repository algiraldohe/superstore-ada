resource "snowflake_warehouse" "warehouse" {
  name = var.warehouse_name
}

resource "snowflake_database" "db" {
  name       = var.database_name
  depends_on = [snowflake_warehouse.warehouse]
}