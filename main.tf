module "gce" {
  source = "./modules/gce"
  cluster_name = var.cluster_name
  project = var.project
  region = var.region
  agent_enabled = var.agent_enabled
}

  module "gke" {
  source = "./modules/gke"
  cluster_name = var.cluster_name
  project = var.project
  region = var.region
  zone = var.zone
  depends_on = [modules.gce]
}
