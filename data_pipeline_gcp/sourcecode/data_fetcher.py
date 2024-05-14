import os
import requests
import csv
from google.cloud import storage
from datetime import datetime
import io

def fetch_and_upload_data():
    url = 'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/rankings/batsmen'
    querystring = {"formatType": "test"}
    headers = {
        "X-RapidAPI-Key": "d7a825d8c8mshb08340a44fcd9c3p18f82bjsn18edf3b47018",
        "X-RapidAPI-Host": "cricbuzz-cricket.p.rapidapi.com"
    }

    try:
        response = requests.get(url, headers=headers, params=querystring)
        print(f"Response Status Code: {response.status_code}, Response: {response.text}")  # Log Response
        if response.status_code == 200:
            data = response.json().get('rank', [])
            csv_filename = 'icc-rankings.csv'

            if data:
                field_names = ['rank', 'name', 'country', 'rating', 'points', 'lastUpdatedOn', 'trend']
                timestamp = datetime.now().strftime("%Y-%m-%d-%H:%M")
                timestamped_csv_filename = f"{timestamp}-{csv_filename}"

                output = io.StringIO()
                writer = csv.DictWriter(output, fieldnames=field_names)
                writer.writeheader()
                for entry in data:
                    writer.writerow({field: entry.get(field) for field in field_names})

                output.seek(0)  # Rewind the StringIO object before reading

                bucket_name = "gcpdatapipeline-420609-gcs-ew1-extract_data_bucket"
                storage_client = storage.Client()
                bucket = storage_client.bucket(bucket_name)
                blob = bucket.blob(timestamped_csv_filename)
                blob.upload_from_string(output.getvalue(), content_type='text/csv')  # Use upload_from_string

                print(f"File '{timestamped_csv_filename}' uploaded to GCS.")
                output.close()
            else:
                print("No Data Found!")
        else:
            print(f"Request failed. Status code: {response.status_code}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    fetch_and_upload_data()