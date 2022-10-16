provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~>2.11.0"
    }
  }
}

resource "helm_release" "blackbox_exporter" {
  skip_crds = false
  name = "blackbox-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus-blackbox-exporter"
  create_namespace = true
}
