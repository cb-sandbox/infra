
output "tomcat_qa_ip" {
  value = "${google_compute_instance_from_machine_image.tomcat_qa.*.network_interface.0.access_config.0.nat_ip, count.index}"
}

output "tomcat_uat_ip" {
  value = "${google_compute_instance_from_machine_image.tomcat_uat.*.network_interface.0.access_config.0.nat_ip, count.index}"
}
