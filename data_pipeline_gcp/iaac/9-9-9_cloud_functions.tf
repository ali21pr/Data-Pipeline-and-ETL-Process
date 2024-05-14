

/*************************************************
           Function source code
*************************************************/

data "archive_file" "gcs_sourcecode" {
  type        = "zip"
  source_dir  = "../sourcecode/cloud_function"
  output_path = "../sourcecode/cloud_function/code.zip"
}

#step2_google_storage_bucket_object
resource "google_storage_bucket_object" "archiver" {
  name   = "code.zip"
  bucket = google_storage_bucket.bucket["gcs_cloud_function"].name
  source = data.archive_file.gcs_sourcecode.output_path
}

/*************************************************
           step4_google_cloud_functions
*************************************************/

resource "google_cloudfunctions_function" "gcs_dataflow_trigger" {

  name                  = "${local.project_id}-fct-${var.name_func}"
  description           = var.description
  runtime               = var.runtime
  entry_point           = var.entry_point
  available_memory_mb   = var.available_memory_mb
  service_account_email = google_service_account.service_account["function_trigger_dataflow"].email
  source_archive_bucket = google_storage_bucket.bucket["gcs_cloud_function"].name
  source_archive_object = google_storage_bucket_object.archiver.name
  # Ajout du déclencheur
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.bucket["gcs_data"].name
  }

  timeout = 540
  labels = {
    my-label = "my-label-value"
  }

  environment_variables = {
    BQ_DESTINATION_DATASET = "gcpdatapipeline-420609.gcpdatapipeline_420609_bqd_rankings"
    BQ_DESTINATION_TABLE   = "gcpdatapipeline-420609.gcpdatapipeline_420609_bqd_rankings.icc-rankings"
    DATAFLOW_WORKER_SA     = google_service_account.service_account["dataflow_job"].email
    PROJECT_ID             = var.project_id
    TEMPLATE_LOCATION      = "gs://gcpdatapipeline-420609-gcs-ew1-bucket_dataflow/templates/batch_template"
  }

  lifecycle {
    replace_triggered_by = [
      google_storage_bucket_object.archiver.md5hash
    ]
  }

}

