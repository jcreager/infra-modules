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

resource "kubernetes_service" "ingress_nginx_metrics" {
  metadata {
    name = "ingress-nginx-metrics"
    labels = {
      monitoring = "prometheus-ingress-nginx"
      "self-monitor" = "true"
      "release" = "kube-prometheus-stack"
    }
  }

  spec {
    port {
      name = "metrics"
      port = 10254
      target_port = 10254
    }
    selector = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance" =  "ingress-nginx"
      "app.kubernetes.io/name" = "ingress-nginx"
    }
  }
}

resource "kubernetes_manifest" "ingress_nginx" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind" = "ServiceMonitor"
    "metadata" = {
      "labels" = {
        "app" = "ingress-nginx"
        "release" = "kube-prometheus-stack"
      }
      "name" = "ingress-nginx-metrics"
      "namespace" = "default"
    }
    "spec" = {
      "endpoints" = [
        {
          "path" = "/metrics"
          "port" = "metrics"
        },
      ]
      "namespaceSelector" = {
        "matchNames" = ["default"]
      }
      "selector" = {
        "matchLabels" = {
          "monitoring" = "prometheus-ingress-nginx"
          "self-monitor" = "true"
          "release" = "kube-prometheus-stack"
        }
      }
    }
  }
}


resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  create_namespace = true
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
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io\\/do-loadbalancer-hostname"
    value = "joecreager.com"
  }
  set {
    name = "controller.config.use-proxy-protocol"
    value = "true"
  }
}
