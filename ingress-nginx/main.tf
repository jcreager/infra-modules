provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate
  }
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
  }
}

resource "helm_release" "ingress-nginx" {
  name = var.site_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  create_namespace = true
}
