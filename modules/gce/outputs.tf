output "tomcat_qa_ip" {
  value = google_compute_instance.tomcat-qa.network_interface.0.access_config.0.nat_ip
}

output "tomcat_uat_ip" {
  value = google_compute_instance.tomcat-uat.network_interface.0.access_config.0.nat_ip
}
