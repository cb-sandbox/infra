data "google_client_config" "default" {}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project
  location = var.location
}

provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

#######################################
# CloudBees CI
#######################################

resource "helm_release" "cloudbees-ci" {
  name             = "cloudbees-ci"
  repository       = "https://public-charts.artifacts.cloudbees.com/repository/public/"
  chart            = "cloudbees-core"
  namespace        = "cloudbees-ci"
  create_namespace = true

  set {
    name  = "OperationsCenter.HostName"
    value = var.ci_hostname
  }

  set {
    name  = "OperationsCenter.Ingress.tls.Enable"
    value = true
  }

  set {
    name  = "OperationsCenter.Ingress.tls.SecretName"
    value = "cjoc-tls"
  }

  set {
    name = "OperationsCenter.Ingress.Annotations.cert-manager\\.io/cluster-issuer"
    value = var.cluster_issuer
  }
}

