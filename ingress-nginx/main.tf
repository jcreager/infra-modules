#provider "helm" {
#  kubernetes {
#    load_config_file = false
#    host                   = var.k8s_host
#    #client_certificate     = base64decode(var.client_certificate)
#    #client_key             = base64decode(var.client_key)
#    token                  = base64decode(var.k8s_token)
#    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
#  }
#}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    cluster_ca_certificate = base64decode(
      var.cluster_ca_certificate
    )

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "doctl"
      args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
      "--version=v1beta1", var.kube_cluster]
    }
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
}
