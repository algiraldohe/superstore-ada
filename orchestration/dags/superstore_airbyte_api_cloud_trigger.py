from airflow.decorators import dag, task
from datetime import datetime
from airflow.hooks.base import BaseHook
from airflow.models import Variable
from airflow.models.baseoperator import chain
from include.superstore.tasks import _trigger_airbyte_sync, _get_sync_status
from airflow.sensors.base import PokeReturnValue
import json
import logging

"""
This file demonstrates a simple Airflow DAG that triggers a sync using the Airbyte API on a connection that 
is running in Airbyte Cloud, and that then waits for that sync to succeed.
The Airbyte API endpoints that are demonstrated are "sync" and "jobs" (status).
For more information, consult the Airbyte API at https://reference.airbyte.com/reference/start

For additional info see: https://airbyte.com/blog/orchestrating-airbyte-api-airbyte-cloud-airflow
"""
AIRBYTE_CONNECTION_ID = Variable.get("AIRBYTE_CONNECTION_ID")
API_KEY = f'Bearer {Variable.get("CLOUD_API_TOKEN")}'
task_logger = logging.getLogger("airflow.task")

@dag(
    start_date=datetime(2023, 1, 1),
    default_args={'owner': 'airflow'},
    schedule='@daily',
    catchup=False,
    tags=['superstore']
)

def airbyte_api_sync():
    api = BaseHook.get_connection('superstore_airbyte_api_cloud_connection')
    url = api.host

    @task()
    def trigger_airbyte_sync():
        # response = _trigger_airbyte_sync(url, API_KEY, AIRBYTE_CONNECTION_ID)
        # task_logger.info("\n" + "="*50 + "\n" + f"🌟🌟🌟 Output JobId = {json.loads(response.text)} 🌟🌟🌟\n" + "="*50)
        # return response.json()['jobId']
        return 22995932
    
    @task.sensor(poke_interval=60, timeout=600, mode='poke')
    def is_sync_complete(job_id: int):
        task_logger.info("\n" + "="*50 + "\n" + f"🌟🌟🌟 Job ID = {job_id} 🌟🌟🌟\n" + "="*50)
        response = _get_sync_status(url=url, bearer=API_KEY, job_id=job_id)
        task_logger.info("\n" + "="*50 + "\n" + f"🌟🌟🌟 Current Job Status = {json.loads(response.text)} 🌟🌟🌟\n" + "="*50)
        condition = json.loads(response.text)['status'] == "succeeded"
        return PokeReturnValue(is_done=condition, xcom_value=json.loads(response.text))
        
    job_id = trigger_airbyte_sync()
    is_sync_complete(job_id)

airbyte_api_sync()