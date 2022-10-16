
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

resource "helm_release" "loki" {
  name = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart = "loki"
  create_namespace = true
  skip_crds = true
}

resource "helm_release" "promtai" {
  name = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart = "promtail"
  create_namespace = true
  skip_crds = true
  values = [
    yamlencode(
      {
        "config" = {
          "clients" = [
            {
              "url" = "http://loki.default.svc.cluster.local:3100/loki/api/v1/push"
            }
          ]
        }
      }
    )
  ]
  #set {
  #  name = "config.clients.0.url"
  #  value = "loki.default.svc.cluster.local:3100/loki/api/v1/push"
  #}
}
