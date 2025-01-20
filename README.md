# Superstore ADA (Airflow DBT Airbyte)
![ADA Architecture](resources/ada_architecture_diagram_v2.png)

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#introduction)
6. [Resources](#resources)

## Introduction

## Installation

## Tech Debt

### Security
 Based on [Airbyte Docs](https://docs.airbyte.com/integrations/sources/s3) authentication through IAM role is not available for OSS and also need to be enabled for Airbyte Cloud by someone in the Airbyte Team, hence secret access key method was used, which is not the most secure. 

Destination = "SNOWFLAKE" not possible to set authentication for user through [Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth) hence a password had to be allocated to the user to authenticate which is not optimal.

## Resources

[S3 Source Configuration](https://docs.airbyte.com/integrations/sources/s3)

[Airbyte Terraform Provider](https://reference.airbyte.com/reference/using-the-terraform-provider#3-create-a-source)

[AWS Secrets for Terraform Credential Management](https://spacelift.io/blog/terraform-secrets)

[Airbyte API Authentication](https://prb68668.us-east-1.snowflakecomputing.com)

[Airflow Setup with Astronomer](https://www.astronomer.io/docs/astro/cli/run-airflow-locally)

[Orchestrate dbt Core jobs with Airflow and Cosmos](https://www.astronomer.io/docs/learn/airflow-dbt/)

[DBT Core + Airflow](https://astronomer.github.io/astronomer-cosmos/)

[Cross DAG Dependencies](https://www.astronomer.io/docs/learn/cross-dag-dependencies/#implement-cross-dag-dependencies)

[Event Driven DAG Schedule](https://www.astronomer.io/docs/learn/airflow-datasets/#conditional-dataset-scheduling)

