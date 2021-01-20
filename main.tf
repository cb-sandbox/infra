module "gke" {
  source = "./modules/gke"
  cluster_name = var.cluster_name
  project = var.project
  region = var.region
  zone = var.zone
}

module "gce" {
  source = "./modules/gce"
  cluster_name = var.cluster_name
  count = var.agent_enabled ? 1 : 0
}
