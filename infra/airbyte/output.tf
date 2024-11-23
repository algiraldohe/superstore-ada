output "airbyte_source_id" {
  description = ""
  value       = airbyte_source_s3.superstore_ada_datasets.source_id
}

output "airbyte_destination_id" {
  description = ""
  value       = airbyte_destination_snowflake.superstore_ada_datasets.destination_id
}

# output "airbyte_connection_name" {
#   description = ""
#   value       = airbyte_connection.s3_to_snowflake_superstore_ada_datasets.name
# }

# output "airbyte_connection_id" {
#   description = ""
#   value       = airbyte_connection.s3_to_snowflake_superstore_ada_datasets.connection_id
# }