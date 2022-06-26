provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
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

resource "helm_release" "certmanager" {
  name = cert-manager
  repository = "https://charts.jetstack.io"
  chart = "jetstack/cert-manager"
  create_namespace = true
}
