# dataflow
/*
resource "google_dataflow_job" "text_to_bigquery" {
  name     = "${local.project_id}-dflw-${var.name_dataflow}"
  project  = var.project_id
  region   = var.region_dataflow
  template_gcs_path = "gs://${google_storage_bucket.bucket["gcs_buckets_dataflow"].name}/templates/batch_template"
  temp_gcs_location = "gs://${google_storage_bucket.bucket["gcs_buckets_dataflow"].name}/tmp"

  parameters = {
    inputFile = "gs://${google_storage_bucket.bucket["gcs_data"].name}/icc-rankings.csv"
    outputTable = "${local.project_id}:${replace(local.project_id,"-","_")}_bqd_${var.datasets["dataset_gcp_dataPipline"].dataset_id}.${var.tables["my_table_icc"].table_id}"
    staging_location = "gs://${google_storage_bucket.bucket["gcs_buckets_dataflow"].name}/staging"
  }
  service_account_email = google_service_account.service_account["dataflow_job"].email
}*/
