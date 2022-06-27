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

resource "kubernetes_manifest" "configmap_wordpress" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "uploads.ini" = <<-EOT
      ; Maximum allowed size for uploaded files.
      upload_max_filesize = 1024M

      ; Must be greater than or equal to upload_max_filesize
      post_max_size = 1024M
      max_execution_time = 500
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app" = "wordpress"
      }
      "name" = "php-ini"
      "namespace" = "default"
    }
  }
}

resource "helm_release" "wordpress" {
  name = var.site_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "wordpress"
  create_namespace = true
  values = [
    yamlencode(
      {
        "extraVolumeMounts" = [
          {
            name = "php-ini"
            "mountPath" = "/opt/bitnami/php/etc/conf.d"
          }
        ]
      }
    ),
    yamlencode(
      {
        "extraVolumes" = [
          {
            name = "php-ini"
            "configMap" = {
              name = "php-ini"
            }
          }
        ]
      }
    )
  ]
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
  set {
    name = "service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "wordpress" {
  metadata {
    name      = "${var.site_name}-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = "167.172.8.60"
      "nginx.ingress.kubernetes.io/enable-cors" = "true"
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "1024m"
      "nginx.ingress.kubernetes.io/client-max-body-size" = "1024m"
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
