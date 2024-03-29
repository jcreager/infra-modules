provider "kubernetes" {
  config_path = "~/.kube/config"
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~>2.11.0"
    }
  }
}

resource "kubernetes_ingress_v1" "wordpress" {
  metadata {
    name      = "${var.site_name}-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = var.static_ip
      "nginx.ingress.kubernetes.io/enable-cors" = "true"
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "1024m"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/permanent-redirect" = var.redirect_to
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
              name = "${var.refers_to}-wordpress"
              port {
                number = 80
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}
