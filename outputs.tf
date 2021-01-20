output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "tomcat_qa_ip" {
  value = module.gce.tomcat_qa_ip
}

output "tomcat_uat_ip" {
  value = module.gce.tomcat_uat_ip
}
