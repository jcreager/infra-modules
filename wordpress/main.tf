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
      version = "~>2.11"
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

resource "kubernetes_secret" "wordpress" {
  metadata {
    name = "${var.site-name}-secrets"
  }
  data = {
    wp_username = "admin"
    wp_password = random_password.wordpress_password.result
  }
}

resource "helm_release" "wordpress" {
  name = var.site_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "wordpress"
  create_namespace = true
  set {
    name = "wordpressUsername"
    value_from {
      secret_key_ref {
        name = kubernetes_secret.wordpress.metadata.name
        key = "wp_username"
      }
    }
  set {
    name = "wordpressPassword"
    value_from {
      secret_key_ref {
        name = kubernetes_secret.wordpress.metadata.name
        key = "wp_password"
      }
    }
  }
  set {
    name = "wordpressConfigureCache"
    value = true
  }
  set {
    name = "ingress.enabled"
    value = true
  }
  set {
    name = "ingress.hostname"
    value = var.site_hostname
  }
  set {
    name = "ingress.extraHosts"
    value = var.site_extra_hostnames
  }
  set {
    name = "ingress.tls"
    value = true
  }
}
