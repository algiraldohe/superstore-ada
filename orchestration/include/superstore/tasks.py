import requests


def _trigger_airbyte_sync(url, bearer, conn_id):
    url = f"{url}/v1/jobs"
    payload = {
        "jobType": "sync",
        "connectionId": conn_id}
    headers = {
            "Content-Type":"application/json",
            "User-Agent": "fake-useragent",  # Airbyte cloud requires that a user agent is defined
            "Accept": "application/json",
            "Authorization": bearer}
    return requests.post(url=url, headers=headers, json=payload)

def _get_sync_status(url, bearer, job_id):
    url = f"{url}/v1/jobs/{job_id}"
    headers = {
        "Accept": "application/json",
        "Authorization": bearer
    }
    return requests.get(url=url, headers=headers)

def _get_airbyte_access_token(url, client_id, client_secret):
    url = f"{url}/v1/applications/token"
    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }
    payload = {
        "client_id": client_id,
        "client_secret": client_secret
    }
    return requests.post(url, json=payload, headers=headers)