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
    kubernetes = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
  }
}

resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  create_namespace = true
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
  set {
    name = "controller.service.monitoring"
    value = "prometheus-ingress-nginx"
  }
}

resource "kubernetes_manifest" "servicemonitor_kube_prometheus_stack_alertmanager" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind" = "ServiceMonitor"
    "metadata" = {
      "name" = "ignress-service-monitor"
      "namespace" = "default"
    }
    "spec" = {
      "namespaceSelector" = {
        "matchNames" = [
          "default",
        ]
      }
      "selector" = {
        "matchLabels" = {
          "monitoring" = "prometheus-ingress-nginx"
        }
      }
    }
  }
}

