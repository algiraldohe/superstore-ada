output "snowflake_database_name" {
    description = ""
    value = snowflake_database.db.name
}

output "snowflake_warehouse_name" {
    description = ""
    value = snowflake_warehouse.warehouse.name
}