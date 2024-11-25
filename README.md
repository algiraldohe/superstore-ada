# Superstore ADA (Airflow DBT Airbyte)


## Tech Debt

### Security
 Based on [Airbyte Docs](https://docs.airbyte.com/integrations/sources/s3) authentication through IAM role is not available for OSS and also need to be enabled for Airbyte Cloud by someone in the Airbyte Team, hence secret access key method was used, which is not the most secure. 

Destination = "SNOWFLAKE" not possible to set authentication for user through [Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth) hence a password had to be allocated to the user to authenticate which is not optimal.

## Resources

[S3 Source Configuration](https://docs.airbyte.com/integrations/sources/s3)

[Airbyte Terraform Provider](https://reference.airbyte.com/reference/using-the-terraform-provider#3-create-a-source)

[AWS Secrets for Terraform Credential Management](https://spacelift.io/blog/terraform-secrets)

[Airbyte API Authentication](https://prb68668.us-east-1.snowflakecomputing.com)