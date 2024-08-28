data "google_client_config" "default" {}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project
  location = var.location
}


terraform {
  required_version = ">= 0.13"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}

#######################################
# Ingress controller
#######################################

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.ingressClassResource.default"
    value = true
  }
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "${helm_release.ingress-nginx.name}-controller"
    namespace = helm_release.ingress-nginx.name
  }

  depends_on = [helm_release.ingress-nginx]
}

resource "google_dns_record_set" "ingress" {
  name         = "*.${var.wildcard_domain}."
  managed_zone = var.dns_zone
  type         = "A"
  ttl          = 300
  project      = var.dns_project

  rrdatas = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.ip]

  depends_on = [data.kubernetes_service.ingress_nginx]
}


#######################################
# Cert manager
#######################################
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = true
  }

  set {
    name  = "crds.keep"
    value = false
  }
}

resource "kubectl_manifest" "staging-issuer" {
  yaml_body       = <<YAML
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: ${var.email}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: staging-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
  depends_on      = [helm_release.cert-manager]
}

resource "kubectl_manifest" "prod-issuer" {
  yaml_body       = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: ${var.email}
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: prod-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
  depends_on      = [helm_release.cert-manager]
}
