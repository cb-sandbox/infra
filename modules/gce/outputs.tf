
output "tomcat_qa_ip" {
  value = length(google_compute_instance.tomcat_qa) > 0 ? google_compute_instance.tomcat_qa.0.network_interface.0.access_config.0.nat_ip : ""
}

output "tomcat_uat_ip" {
  value = length(google_compute_instance.tomcat_uat) > 0 ? google_compute_instance.tomcat_uat.0.network_interface.0.access_config.0.nat_ip : ""
}
