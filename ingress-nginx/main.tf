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

resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  create_namespace = true
  values = [
    yamlencode(
      {
        "controller" = {
          "podAnnotations" = {
            "prometheus.io/scrape" = "true"
            "prometheus.io/port" = "10254"
          }
          "service" = {
            "labels" = {
              "monitoring" = "prometheus-ingress-nginx"
            }
          }
        }
      }
    )
  ]
  set {
    name = "controller.service.metrics.enabled"
    value = "true"
  }
  set {
    name = "controller.service.metrics.serviceMonitor.enabled"
    value = "true"
  }
  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io\\/do-loadbalancer-enable-proxy-protocol"
    value = "true"
  }
  set {
    name = "controller.config.use-proxy-protocol"
    value = "true"
  }
  #set {
  #  name = "controller.service.labels.monitoring"
  #  value = "prometheus-ingress-nginx"
  #}
}
