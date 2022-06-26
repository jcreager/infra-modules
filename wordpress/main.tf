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

resource "helm_release" "wordpress" {
  name = var.site_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "wordpress"
  create_namespace = true
}
