variable "airbyte_snowflake_host" {
  type        = string
  description = ""
}

variable "airbyte_snowflake_user" {
  type        = string
  description = ""
}

variable "snowflake_schema_name" {
  type        = string
  description = ""
  default     = "PUBLIC"

}