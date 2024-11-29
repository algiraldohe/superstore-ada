from airflow.decorators import dag, task
from datetime import datetime
from airflow.hooks.base import BaseHook
from airflow.models import Variable
from airflow.models.baseoperator import chain
from include.superstore.tasks import _trigger_airbyte_sync, _get_sync_status, _get_airbyte_access_token
from airflow.sensors.base import PokeReturnValue
import json
from airflow.datasets import Dataset
import logging

"""
This file demonstrates a simple Airflow DAG that triggers a sync using the Airbyte API on a connection that 
is running in Airbyte Cloud, and that then waits for that sync to succeed.
The Airbyte API endpoints that are demonstrated are "sync" and "jobs" (status).
For more information, consult the Airbyte API at https://reference.airbyte.com/reference/start

For additional info see: https://airbyte.com/blog/orchestrating-airbyte-api-airbyte-cloud-airflow
"""

# Airflow env variables 
AIRBYTE_CONNECTION_ID = Variable.get("AIRBYTE_CONNECTION_ID")
API_KEY = f'Bearer {Variable.get("CLOUD_API_TOKEN")}'
AIRBYTE_CLIENT_ID = Variable.get("AIRBYTE_CLIENT_ID")
AIRBYTE_CLIENT_SECRET = Variable.get("AIRBYTE_CLIENT_SECRET")

# Datasets 
DAG_OPS = Dataset("file://localhost/airflow/include/dag_ops.txt")

# Logging
task_logger = logging.getLogger("airflow.task")

@dag(
    start_date=datetime(2023, 1, 1),
    default_args={'owner': 'airflow'},
    schedule='@daily',
    catchup=False,
    tags=['superstore', 'load']
)

def airbyte_api_sync():
    api = BaseHook.get_connection('superstore_airbyte_api_cloud_connection')
    url = api.host

    @task.sensor(poke_interval=5, timeout=30, mode='poke')
    def fetch_access_token():
        response = _get_airbyte_access_token(url=url, client_id=AIRBYTE_CLIENT_ID, client_secret=AIRBYTE_CLIENT_SECRET)
        condition = response.json()["access_token"] is not None
        return PokeReturnValue(is_done=condition, xcom_value=response.json()["access_token"])

    @task()
    def trigger_airbyte_sync(access_token: str):
        access_token = f"Bearer {access_token}"
        response = _trigger_airbyte_sync(url, access_token, AIRBYTE_CONNECTION_ID)
        task_logger.info("\n" + "="*50 + "\n" + f"🌟🌟🌟 Output JobId = {json.loads(response.text)} 🌟🌟🌟\n" + "="*50)
        return response.json()['jobId']
    
    @task.sensor(poke_interval=60, timeout=1800, mode='poke')
    def is_sync_complete(job_id: int, access_token: str):
        access_token = f"Bearer {access_token}"
        response = _get_sync_status(url=url, bearer=access_token, job_id=job_id)
        task_logger.info("\n" + "="*50 + "\n" + f"🌟🌟🌟 Current Job Status = {json.loads(response.text)} 🌟🌟🌟\n" + "="*50)
        condition = json.loads(response.text)['status'] == "succeeded"
        return PokeReturnValue(is_done=condition, xcom_value=json.loads(response.text))
    
    @task(outlets=[DAG_OPS])
    def trigger_downstream_dag(response):
        msg = "\n" + "="*50 + "\n" + f"🌟🌟🌟 DAG execution succeeded = {response['status'] == "succeeded"} 🌟🌟🌟\n" + "="*50
        task_logger.info(msg)
        f = open("include/dag_ops.txt", "a")
        f.write(msg)
        f.close()


        
    # Establishing dependencies through Xcoms
    access_token = fetch_access_token()
    job_id = trigger_airbyte_sync(access_token)
    response = is_sync_complete(job_id, access_token)
    trigger_downstream_dag(response)

airbyte_api_sync()