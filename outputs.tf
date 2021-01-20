output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "tomcat_qa_ip" {
  value = var.agent_enabled ? module.gce.tomcat_qa_ip : false
}

output "tomcat_uat_ip" {
  value = var.agent_enabled ? module.gce.tomcat_uat_ip : false
}
