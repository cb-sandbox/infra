provider "google-beta" {
  project = var.project
  region = var.region
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "tomcat" {
  name = "${var.cluster_name}-tomcat"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports = [
      "8080",
      "7800",
      "3306"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"]

  target_tags = [
    "tomcat"]
}

resource "google_compute_disk" "tomcat_qa" {
    name  = "${var.cluster_name}-tomcat-agent-qa"
    type  = "pd-balanced"
    zone  = "us-central1-a"
    snapshot = "tomcat-agent-snapshot-1"
    size = 10
}
resource "google_compute_instance" "tomcat_qa" {
  name = "${var.cluster_name}-tomcat-agent-qa"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  count = var.agent_enabled ? 1 : 0

  boot_disk {
    source = resource.google_compute_disk.tomcat_qa.name
    device_name = "cdagent-tomcat-mysql2"
  }

  network_interface {
    network = data.google_compute_network.default.name
  }

  provider = google-beta
  tags = [
    "tomcat"]
}

resource "google_compute_disk" "tomcat_uat" {
    name  = "${var.cluster_name}-tomcat-agent-qa"
    type  = "pd-balanced"
    zone  = "us-central1-a"
    snapshot = "tomcat-agent-snapshot-1"
    size = 10
}
resource "google_compute_instance" "tomcat_uat" {
  name = "${var.cluster_name}-tomcat-agent-uat"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  boot_disk {
    source = resource.google_compute_disk.tomcat_uat.name
    device_name = "cdagent-tomcat-mysql2"
  }

  network_interface {
    network = data.google_compute_network.default.name
  }

  count = var.agent_enabled ? 1 : 0

  provider = google-beta
  tags = [
    "tomcat"]

}
