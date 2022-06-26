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
  set {
    name = "ingress.enabled"
    value = true
  }
  set {
    name = "ingress.hostname"
    value = var.site_hostname
  }
  #set {
  #  name = "ingress.extraHosts"
  #  value = "{${join(",", var.site_extra_hostnames)}}"
  #}
  #set {
  #  name = "ingress.extraTls"
  #  value = "{${join(",", var.site_extra_hostnames)}}"
  #}
  set {
    name = "ingress.tls"
    value = true
  }
  set {
    name = "service.type"
    value = "ClusterIP"
  }
  set {
    name = "ingress.certManager"
    value = true
  }
  set {
    name = "ingress.annotations.kubernetes\.io/ingress\.class"
    value = "nginx"
  }
  set {
    name = "ingress.annotations.cert-manager\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }
}
