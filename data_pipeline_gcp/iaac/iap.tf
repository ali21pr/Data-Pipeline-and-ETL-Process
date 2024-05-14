resource "google_compute_firewall" "firewall_rules" {
  for_each = var.firewall_rules

  name    = "${local.project_id}-${each.key}"
  network = google_compute_network.composer_network.id

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
}