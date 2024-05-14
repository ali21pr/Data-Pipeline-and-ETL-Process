# table BigQuery
resource "google_bigquery_table" "table" {
  for_each   = var.tables
  dataset_id = "${replace(local.project_id, "-", "_")}_bqd_${each.value.dataset_id}"
  table_id   = each.value.table_id
  schema     = jsonencode(each.value.schema)
}

