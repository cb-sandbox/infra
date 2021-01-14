data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "tomcat" {
  name = "tomcat"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["tomcat"]
}

resource "google_compute_instance" "default" {
  name = "${var.cluster_name}-agent-${count.index}"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  tags = ["tomcat"]

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata_startup_script = file("${path.module}/install.sh")

  count = var.agent_count
}

