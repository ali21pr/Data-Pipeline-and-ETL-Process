
resource "google_compute_firewall" "composer_sql_egress" {
  name    = "composer-sql-egress"
  network = google_compute_network.composer_network.id

  direction = "EGRESS"
  priority  = 1000

  destination_ranges = ["35.191.0.0/16", "130.211.0.0/22"] # Plages IP utilisées par Google Services

  allow {
    protocol = "tcp"
    ports    = ["3306", "3307"]
  }

  # Cette règle s'appliquera à toutes les instances dans le VPC
}