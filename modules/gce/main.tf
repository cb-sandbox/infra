data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "tomcat" {
  name    = "${var.cluster_name}-tomcat"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports = [
    "8080"]
  }

  source_ranges = [
  "0.0.0.0/0"]

  target_tags = [
  "tomcat"]
}

data "google_compute_machine_image" "tomcat" {
  name    = "lowtouch-tomcat-mysql-agent"
  project = var.project
}


resource "google_compute_instance_from_machine_image" "tomcat_qa" {
  name         = "${var.cluster_name}-tomcat-agent-qa"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  source_machine_image = data.google_compute_machine_image.tomcat

  tags = [
  "tomcat"]
}


resource "google_compute_instance_from_machine_image" "tomcat_uat" {
  name         = "${var.cluster_name}-tomcat-agent-uat"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  source_machine_image = data.google_compute_machine_image.tomcat


  tags = [
  "tomcat"]

}
