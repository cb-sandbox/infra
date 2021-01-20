output "tomcat_qa_ip" {
  value = google_compute_instance.tomcat_qa.network_interface.0.access_config.0.nat_ip
}

output "tomcat_uat_ip" {
  value = google_compute_instance.tomcat_uat.network_interface.0.access_config.0.nat_ip
}
