provider "google" {
  project         = "gcpdatapipeline-420609"
  region          = "europe-west1"
  request_timeout = "10m"
}

provider "google-beta" {
  project = "gcpdatapipeline-420609"
  region  = "europe-west1"
}