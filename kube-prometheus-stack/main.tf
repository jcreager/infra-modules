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
  values = [
    yamlencode(
      {
        ingress.enabled = true
        hosts = [var.grafana_host]
        tls = [
          {
            secretName = var.tls_secret_name
            hosts = [var.grafana_host]
          }
        ]
      }
    )
  ]
}
