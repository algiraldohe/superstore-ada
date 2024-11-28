FROM quay.io/astronomer/astro-runtime:12.4.0-python-3.12-slim

COPY ./dbt ./

RUN python -m venv .ada_venv \
 && . .ada_venv/bin/activate \
 && pip install --no-cache-dir dbt-snowflake==1.8.4 \
 && deactivate
