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

resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  create_namespace = true
  skip_crds = true
  set {
    name = "grafana.ingress.enbled"
    value = true
  }
  set {
    name = "grafana.ingress.hosts.0"
    value = var.grafana_host
  }
  set {
    name = "grafana.ingress.tls.0.secretName"
    value = var.tls_secret_name
  }
  set {
    name = "grafana.ingress.tls.0.hosts.0"
    value = var.grafana_host
  }
}
