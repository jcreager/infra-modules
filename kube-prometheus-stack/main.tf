provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
  }
}

resource "kubernetes_secret" "additional_scrape_configs" {
  metadata {
    name = "additional-scrape-configs"
  }
  data = {
    "additional-scrape-configs.yaml" = var.scrape_configs
  }
  type = "Opaque"
}

resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  create_namespace = true
  skip_crds = true
    set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigsSecret.enabled"
    value = true
  }
  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigsSecret.name"
    value = "additional-scrape-configs"
  }
  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigsSecret.key"
    value = "additional-scrape-configs.yaml"
  }
}

