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
    name = "controller.service.annotations"
    value = "service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol: \"true\""
  }
}
