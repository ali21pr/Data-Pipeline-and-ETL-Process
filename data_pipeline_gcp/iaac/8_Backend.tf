terraform {
  backend "gcs" {
    bucket = "gcpdatapipeline-420609-gcs-ew1-bucket_backend"
    prefix = "terraform"
  }
}