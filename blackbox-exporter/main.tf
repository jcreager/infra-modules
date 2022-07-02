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
  name = "cert-manager"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus-blackbox-exporter"
  create_namespace = true
}

resource "kubernetes_secret" "scrape_configs" {
  metadata {
    name = "scrape-configs"
  }

  data = {
    "scrape-configs.yaml" = var.scrape_configs
  }

  type = "Opaque"
}
