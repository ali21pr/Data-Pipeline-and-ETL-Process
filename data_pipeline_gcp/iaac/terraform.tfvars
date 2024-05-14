# Service Accounts
service_accounts = {
  function_trigger_dataflow = {
    purpose      = "function-trigger-dataflow",
    display_name = "service account for cloud function to alllow acces to bucket GCS",
    description  = "STANDARD"
  }
  load_to_gcs = {
    purpose      = "load-to-gcs",
    display_name = "service account to load data to bucket GCS",
    description  = "STANDARD"
  }
  dataflow_job = {
    purpose      = "dataflow-job",
    display_name = "service account to dataflow",
    description  = "STANDARD"
  }
  composer_orchestration = {
    purpose      = "composer-orchestration",
    display_name = "Custom Service Account for Cloud Composer",
    description  = "STANDARD"
  }
  compute_sa = {
    purpose      = "compute-sa"
    display_name = "service account for the compute engine"
    description  = "STANDARD"
  }

}
# GCS Buckets
buckets = {
  gcs_data = {
    identifier         = "extract_data_bucket"
    location           = "europe-west1"
    storage_class      = "STANDARD"
    versioning_enabled = "false"
  }
  gcs_buckets_backend = {
    identifier         = "bucket_backend"
    location           = "europe-west1"
    storage_class      = "STANDARD"
    versioning_enabled = "false"
  }
  gcs_buckets_dataflow = {
    identifier         = "bucket_dataflow"
    location           = "europe-west1"
    storage_class      = "STANDARD"
    versioning_enabled = "false"
  }
  gcs_cloud_function = {
    identifier         = "gcs_cloud_function"
    location           = "europe-west1"
    storage_class      = "STANDARD"
    versioning_enabled = "false"
  }
}

# Datasets Bigquery

datasets = {
  dataset_gcp_dataPipline = {
    dataset_id          = "rankings"
    location_dataset    = "europe-west1"
    description_dataset = "this is project of RapidApi"
  }
}

# Table Bigquery

tables = {
  my_table_icc = {
    table_id   = "icc-rankings"
    dataset_id = "rankings"
    schema = [
      {
        name = "rank"
        type = "INTEGER"
      },
      {
        name = "name"
        type = "STRING"
      },
      {
        name = "country"
        type = "STRING"
      },
      {
        name = "rating"
        type = "INTEGER"
      },
      {
        name = "points"
        type = "INTEGER"
      },
      {
        name = "lastUpdatedOn"
        type = "DATE"
      },
      {
        name = "trend"
        type = "STRING"
      },

    ]
  }
}

# dataflow 
project_id      = "gcpdatapipeline-420609"
name_dataflow   = "data_to_bq"
region_dataflow = "africa-south1"

# Api to Activate 

activate_apis = [
  "cloudresourcemanager.googleapis.com",
  "bigquery.googleapis.com",
  "pubsub.googleapis.com",
  "dataflow.googleapis.com",
  "cloudfunctions.googleapis.com",
  "deploymentmanager.googleapis.com",
  "cloudbuild.googleapis.com",
  "monitoring.googleapis.com",
  "iap.googleapis.com",
  "osconfig.googleapis.com",
  "serviceusage.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "oslogin.googleapis.com",
  "cloudtrace.googleapis.com",
  "storage-api.googleapis.com",
  "servicenetworking.googleapis.com",
  "clouderrorreporting.googleapis.com",
  "storage-component.googleapis.com",
  "stackdriver.googleapis.com",
  "logging.googleapis.com",
  "secretmanager.googleapis.com",
  "composer.googleapis.com",
  "container.googleapis.com",
  "servicedirectory.googleapis.com",
  "datacatalog.googleapis.com"
]

#google cloud function 

name_func           = "gcs_trigger_dataflow"
description         = "My function triggered by event finalized and trigger a dataflow job"
runtime             = "python38"
entry_point         = "startDataflowProcess"
available_memory_mb = 256

# vpc
name_vpc                = "airflow"
auto_create_subnetworks = false

#subnet
name_subnet                 = "airflow"
region_subnet               = "europe-west1"
ip_cidr_range               = "10.0.0.0/28"
range_namesecondry_pods     = "airflow-pods"
ip_cidr_range_secondry_pods = "172.30.160.0/23"
range_namesecondry_svc      = "airflow-svc"
ip_cidr_range_secondry_svc  = "172.30.192.0/27"

# Cloud Composer 
name_composer_environment = "environment"
machine_type              = "n1-standard-2"
image_version             = "composer-2-airflow-2"
node_count                = 4

# Compute Engine 
compute_machine_type = "e2-small"
zone                 = "europe-west1-b"
name_instance        = "compute-airflow"
tags                 = ["iap-ssh", "http-server", "https-server", "airflow-web", "ssh-server"]
#image                = "debian-cloud/debian-11"

#iap
firewall_rules = {
  ssh = {
    protocol = "tcp"
    ports    = ["22"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["ssh-server"]
  },
  iap-ssh = {
  protocol = "tcp"
  ports    = ["22"]
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
  },
  http = {
    protocol = "tcp"
    ports    = ["80"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["http-server"]
  },
  https = {
    protocol = "tcp"
    ports    = ["443"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["https-server"]
  },
  airflow = {
    protocol = "tcp"
    ports    = ["8080"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["airflow-web"]
  }
}
