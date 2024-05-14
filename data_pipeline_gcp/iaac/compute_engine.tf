resource "random_integer" "sequential_number" {
  min = 20000
  max = 50000
}

resource "google_compute_instance" "Compute_engine_project" {
  name         = "${local.project_id}-gce-lnx-${var.name_instance}-${random_integer.sequential_number.result}"
  machine_type = var.compute_machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.composer_subnetwork.name
    access_config {
  // Ce bloc est suffisant pour obtenir une adresse IP externe éphémère.
    }
  }
  tags = var.tags

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service_account["compute_sa"].email
    scopes = ["cloud-platform"]
  }
  metadata = {
    startup-script = <<EOF
#!/bin/bash
sudo apt update
sudo apt -y install python3-pip
pip3 install apache-airflow
airflow db init
EOF
  }
}



