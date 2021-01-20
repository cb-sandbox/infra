data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "tomcat" {
  name = "${var.cluster_name}-tomcat"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["tomcat"]
}

data "google_compute_image" "tomcat" {
  name = "lowtouch-tomcat-mysql-agent"
}

resource "google_compute_instance" "tomcat-qa" {
  name = "${var.cluster_name}-tomcat-agent-qa"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.tomcat
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
}


resource "google_compute_instance" "tomcat-uat" {
  name = "${var.cluster_name}-tomcat-agent-uat"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.tomcat
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
}

