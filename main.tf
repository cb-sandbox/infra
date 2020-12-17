module "gke" {
  source = "./modules/gke"
  cluster_name = var.cluster_name
  project = var.project
  region = var.region
  zone = var.zone
}
