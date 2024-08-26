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
