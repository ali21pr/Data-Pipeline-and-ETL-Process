# IAM Project_level 

module "projects_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.6"
  projects = [local.project_id]

  bindings = {
    "roles/iam.securityAdmin" = [
      "serviceAccount:63040508589@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudfunctions.admin" = [
      "serviceAccount:63040508589@cloudbuild.gserviceaccount.com",
      "serviceAccount:${google_service_account.service_account["function_trigger_dataflow"].email}"
    ]
    "roles/editor" = [
      "serviceAccount:63040508589@cloudbuild.gserviceaccount.com",
      "serviceAccount:${google_service_account.service_account["composer_orchestration"].email}"
    ]
    "roles/cloudbuild.builds.editor" = [
      "serviceAccount:63040508589@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudbuild.serviceAgent" = [
      "serviceAccount:63040508589@cloudbuild.gserviceaccount.com"
    ]
    "roles/storage.admin" = [
      "serviceAccount:${google_service_account.service_account["function_trigger_dataflow"].email}",
      "serviceAccount:${google_service_account.service_account["dataflow_job"].email}"
    ]

    "roles/storage.objectCreator" = [
      "serviceAccount:${google_service_account.service_account["load_to_gcs"].email}"
    ]

    "roles/dataflow.admin" = [
      "serviceAccount:${google_service_account.service_account["dataflow_job"].email}",
      "serviceAccount:${google_service_account.service_account["function_trigger_dataflow"].email}"
    ]
    "roles/dataflow.worker" = [
      "serviceAccount:${google_service_account.service_account["dataflow_job"].email}"
    ]
    "roles/bigquery.dataEditor" = [
      "serviceAccount:${google_service_account.service_account["dataflow_job"].email}"
    ]
    "roles/bigquery.jobUser" = [
      "serviceAccount:${google_service_account.service_account["dataflow_job"].email}"
    ]
    "roles/composer.admin" = [
      "serviceAccount:${google_service_account.service_account["composer_orchestration"].email}"
    ]
    "roles/composer.worker" = [
      "serviceAccount:${google_service_account.service_account["composer_orchestration"].email}"
    ]
    "roles/storage.objectAdmin" = [
      "serviceAccount:${google_service_account.service_account["composer_orchestration"].email}",
      "serviceAccount:${google_service_account.service_account["compute_sa"].email}"
    ]

  }

}

