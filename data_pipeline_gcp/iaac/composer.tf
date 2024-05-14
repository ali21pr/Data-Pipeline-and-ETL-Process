resource "google_compute_firewall" "composer_firewall" {
  name    = "allow-internal-composer"
  network = google_compute_network.composer_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/24"]
}
/*
# Configuration de l'environnement Composer avec le réseau spécifié
resource "google_composer_environment" "environment" {
  name   = "composer-${var.name_composer_environment}"
  region = "europe-west1"

  config {
    node_config {
      network    = google_compute_network.composer_network.id
      subnetwork = google_compute_subnetwork.composer_subnetwork.id

      # Spécifiez le service account ici
      service_account = google_service_account.service_account["composer_orchestration"].email
    }

    software_config {
      image_version = var.image_version
    }

    workloads_config {
      scheduler {
        cpu        = 1
        memory_gb  = 1.5
        storage_gb = 2
      }
      web_server {
        cpu        = 1
        memory_gb  = 1.5
        storage_gb = 2
      }
      worker {
        cpu        = 1
        memory_gb  = 1.5
        storage_gb = 2
      }
    }
  }
}
*/
