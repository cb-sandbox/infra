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


resource "google_compute_instance_from_machine_image" "tomcat_qa" {
  name = "${var.cluster_name}-tomcat-agent-qa"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  count = var.agent_enabled ? 1 : 0

  source_machine_image = "projects/${var.project}/global/machineImages/cdagent-tomcat-mysql"

  provider = google-beta
  tags = [
    "tomcat"]
}


resource "google_compute_instance_from_machine_image" "tomcat_uat" {
  name = "${var.cluster_name}-tomcat-agent-uat"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"

  source_machine_image = "projects/${var.project}/global/machineImages/cdagent-tomcat-mysql"

  count = var.agent_enabled ? 1 : 0

  provider = google-beta
  tags = [
    "tomcat"]

}
