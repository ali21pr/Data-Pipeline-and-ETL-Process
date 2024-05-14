
resource "google_compute_network" "composer_network" {
  name                    = "${local.project_id}-vpc-${var.name_vpc}"
  auto_create_subnetworks = var.auto_create_subnetworks # Important pour contrôler manuellement la création de sous-réseaux
}

resource "google_compute_subnetwork" "composer_subnetwork" {
  name          = "${local.project_id}-subnet-${var.name_subnet}"
  region        = var.region_subnet
  network       = google_compute_network.composer_network.id
  ip_cidr_range = var.ip_cidr_range
  secondary_ip_range {
    range_name    = var.range_namesecondry_pods
    ip_cidr_range = var.ip_cidr_range_secondry_pods
  } # Assurez-vous que cette plage CIDR ne chevauche pas d'autres réseaux
  secondary_ip_range {
    range_name    = var.range_namesecondry_svc
    ip_cidr_range = var.ip_cidr_range_secondry_svc
  }
}