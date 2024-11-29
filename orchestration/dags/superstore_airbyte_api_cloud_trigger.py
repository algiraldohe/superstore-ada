from airflow.decorators import dag, task
from datetime import datetime
from airflow.providers.http.operators.http import SimpleHttpOperator
from airflow.providers.http.sensors.http import HttpSensor
from airflow.models import Variable
from airflow.models.baseoperator import chain
import json

"""
This file demonstrates a simple Airflow DAG that triggers a sync using the Airbyte API on a connection that 
is running in Airbyte Cloud, and that then waits for that sync to succeed.
The Airbyte API endpoints that are demonstrated are "sync" and "jobs" (status).
For more information, consult the Airbyte API at https://reference.airbyte.com/reference/start

For additional info see: https://airbyte.com/blog/orchestrating-airbyte-api-airbyte-cloud-airflow
"""
AIRBYTE_CONNECTION_ID = Variable.get("AIRBYTE_CONNECTION_ID")
API_KEY = f'Bearer {Variable.get("CLOUD_API_TOKEN")}'

@dag(
    start_date=datetime(2023, 1, 1),
    default_args={'owner': 'airflow'},
    schedule='@daily',
    catchup=False,
    tags=['superstore']
)

def airbyte_api_sync_demo():
    trigger_sync = SimpleHttpOperator(
        method="POST",
        task_id='start_airbyte_sync',
        http_conn_id='superstore_airbyte_api_cloud_connection',
        headers={
            "Content-Type":"application/json",
            "User-Agent": "fake-useragent",  # Airbyte cloud requires that a user agent is defined
            "Accept": "application/json",
            "Authorization": API_KEY},
        endpoint=f'/v1/jobs',
        data=json.dumps({"connectionId": AIRBYTE_CONNECTION_ID, "jobType": "sync"}),
        do_xcom_push=True,
        response_filter=lambda response: response.json()['jobId'],
        log_response=True,
    )

    wait_for_sync_to_complete = HttpSensor(
        method='GET',
        task_id='wait_for_airbyte_sync',
        http_conn_id='superstore_airbyte_api_cloud_connection',
        headers={
            "Content-Type":"application/json",
            "User-Agent": "fake-useragent",  # Airbyte cloud requires that a user agent is defined
            "Accept": "application/json",
            "Authorization": API_KEY},
        endpoint='/v1/jobs/{}'.format("{{ task_instance.xcom_pull(task_ids='start_airbyte_sync') }}"),
        poke_interval=5,
        response_check=lambda response: json.loads(response.text)['status'] == "succeeded"
    )

    chain(
        trigger_sync,
        wait_for_sync_to_complete
        )

airbyte_api_sync_demo()



