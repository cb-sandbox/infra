
data "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project
  location = var.location
}


terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.15.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
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

