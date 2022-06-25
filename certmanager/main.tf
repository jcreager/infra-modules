provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate
  }
}

terraform {
  backend "s3" {}
  required_providers {
    kubernetes = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
  }
}

resource "helm_release" "certmanager" {
  name = var.site_name
  repository = "https://charts.jetstack.io"
  chart = "jetstack/cert-manager"
  create_namespace = true
}
