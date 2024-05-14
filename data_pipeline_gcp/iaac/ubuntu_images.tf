data "google_compute_image" "ubuntu_image" {
  family  = "ubuntu-minimal-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}
