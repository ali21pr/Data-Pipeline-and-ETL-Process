from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta

# arguments par défaut
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 5, 7),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Création du DAG
dag = DAG(
    'fetch_and_upload_data',
    default_args=default_args,
    description='Fetch data and upload to GCS',
    schedule_interval='0 8 * * *',  # À 8h00 UTC (qui sera 9h00 ou 10h00 à Paris selon l'heure d'été)
    catchup=False
)

def fetch_and_upload_data():
    # chercher et charger les données ici
    import os
    import requests
    import csv
    from google.cloud import storage
    from datetime import datetime
    import io

    url = 'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/rankings/batsmen'
    querystring = {"formatType": "test"}
    headers = {
        "X-RapidAPI-Key": "d7a825d8c8mshb08340a44fcd9c3p18f82bjsn18edf3b47018",
        "X-RapidAPI-Host": "cricbuzz-cricket.p.rapidapi.com"
    }

    response = requests.get(url, headers=headers, params=querystring)
    if response.status_code == 200:
        data = response.json().get('rank', [])
        csv_filename = 'icc-rankings.csv'

        if data:
            field_names = ['rank', 'name', 'country', 'rating', 'points', 'lastUpdatedOn', 'trend']
            timestamp = datetime.now().strftime("%Y-%m-%d-%H:%M")
            timestamped_csv_filename = f"{timestamp}-{csv_filename}"

            output = io.StringIO()
            writer = csv.DictWriter(output, fieldnames=field_names)
            #writer.writeheader()
            for entry in data:
                writer.writerow({field: entry.get(field) for field in field_names})

            output.seek(0)  # Rewind the StringIO object before reading

            bucket_name = "gcpdatapipeline-420609-gcs-ew1-extract_data_bucket"
            storage_client = storage.Client()
            bucket = storage_client.bucket(bucket_name)
            blob = bucket.blob(timestamped_csv_filename)
            blob.upload_from_file(output, content_type='text/csv')

            print(f"File '{timestamped_csv_filename}' uploaded to GCS.")
            output.close()
        else:
            print("No Data Found!")
    else:
        print(f"Request failed. Status code: {response.status_code}")

# Création de la tâche PythonOperator
fetch_data_task = PythonOperator(
    task_id='fetch_and_upload_data_task',
    python_callable=fetch_and_upload_data,
    dag=dag
)