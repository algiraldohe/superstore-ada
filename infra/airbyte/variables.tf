variable "bucket_name" {
  type        = string
  description = ""
}

variable "region_name" {
  type        = string
  description = ""
}

variable "airbyte_service_role_arn" {
  type = string
  description = ""
}

variable "airbyte_workspace_id" {
    type = string
    description = ""
}

variable "aws_profile" {
    type = string
    description = ""
}