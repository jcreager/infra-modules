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
    random = {
      source = "hashicorp/random"
      version = "~>3.3"
    }
  }
}

resource "random_password" "wordpress_password" {
  length = 32
}

resource "helm_release" "wordpress" {
  name = var.site_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "wordpress"
  create_namespace = true
  set {
    name = "wordpressUsername"
    value = "admin"
  }
  set {
    name = "wordpressPassword"
    value = random_password.wordpress_password.result
  }
  set {
    name = "wordpressConfigureCache"
    value = true
  }
}

resource "kubernetes_ingress_v1" "wordpress" {
  metadata {
    name      = "${var.site_name}-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "1024m"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }
  spec {
    tls {
      hosts = [var.site_hostname]
      secret_name = "${var.site_name}-tls"
    }
    rule {
      host = var.site_hostname
      http {
        path {
          backend {
            service {
              name = "${var.site_name}-wordpress"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}
