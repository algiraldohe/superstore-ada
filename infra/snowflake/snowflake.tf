resource "snowflake_warehouse" "warehouse" {
  name = var.warehouse_name
}

resource "snowflake_database" "db" {
  name       = var.database_name
  depends_on = [snowflake_warehouse.warehouse]
}

resource "snowflake_schema" "schema" {
  database = var.database_name
  name     = var.schema_name
  comment  = "Schema coming from terraform"

  is_transient = false
  depends_on   = [snowflake_database.db]
}