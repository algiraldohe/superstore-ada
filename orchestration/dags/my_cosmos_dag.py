from datetime import datetime
import os
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
from pathlib import Path

airflow_home = os.environ["AIRFLOW_HOME"]
dbt_project_path = Path(f"{airflow_home}/dbt/superstore")

profile_config = ProfileConfig(profile_name="superstore",
                               target_name="dev",
                               profile_mapping=SnowflakeUserPasswordProfileMapping(conn_id="superstore_snowflake", 
                                                    profile_args={
                                                        "database": "TF_DAVERSE_DEV",
                                                        "schema": "TF_BRONZE_DEV"
                                                        },
                                                    ))


dbt_snowflake_dag = DbtDag(project_config=ProjectConfig(dbt_project_path,),
                    operator_args={"install_deps": True},
                    profile_config=profile_config,
                    execution_config=ExecutionConfig(dbt_executable_path=f"{airflow_home}/.ada_venv/bin/dbt",),
                    schedule_interval="@daily",
                    start_date=datetime(2024, 11, 27),
                    catchup=False,
                    dag_id="dbt_snowflake_dag",)