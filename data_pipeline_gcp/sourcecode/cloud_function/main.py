import os
from googleapiclient.discovery import build

def startDataflowProcess(data, context):
    BQ_DESTINATION_DATASET = os.getenv("BQ_DESTINATION_DATASET")
    DATAFLOW_WORKER_SA = os.getenv("DATAFLOW_WORKER_SA")
    PROJECT_ID = os.getenv("PROJECT_ID")
    TEMPLATE_LOCATION = os.getenv("TEMPLATE_LOCATION")

    # Récupération du nom du fichier depuis l'événement de déclenchement
    file_name = data['name']
    print("Detected file:", file_name)

    # Correction des chemins pour inputFile, staging_location, et tempLocation
    bucket_name_data = "gcpdatapipeline-420609-gcs-ew1-extract_data_bucket"  # Bucket pour les fichiers d'input
    bucket_name_temp = "gcpdatapipeline-420609-gcs-ew1-bucket_dataflow"  # Bucket pour temp et staging

    inputFile = f"gs://{bucket_name_data}/{file_name}"  # Chemin complet de l'input file
    staging_location = f"gs://{bucket_name_temp}/staging"  # Emplacement staging correct
    temp_location = f"gs://{bucket_name_temp}/temp"  # Emplacement temp correct

    # Construction du nom de la table de sortie
    file_prefix = file_name.split('.')[0].replace('-', '_')  # Remplace les tirets par des underscores
    table_name = file_prefix.replace(':', '_').replace('.', '_')  # Replace problematic characters
    outputTable = f"{BQ_DESTINATION_DATASET}.{table_name}"

    job_name = PROJECT_ID + "-dfj-gcs-to-bq-" + str(data['timeCreated'])

    parameters = {
        "inputFile": inputFile,
        "outputTable": outputTable,
        "staging_location": staging_location
    }

    environment = {
        "tempLocation": temp_location,
        "serviceAccountEmail": DATAFLOW_WORKER_SA
    }

    service = build('dataflow', 'v1b3', cache_discovery=False)
    request = service.projects().locations().templates().launch(
        projectId=PROJECT_ID,
        gcsPath=TEMPLATE_LOCATION,
        location='africa-south1',
        body={
            "jobName": job_name,
            "parameters": parameters,
            "environment": environment
        },
    )
    response = request.execute()
    print(str(response))

