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

resource "kubernetes_secret" "repo_creds" {
  metadata {
    name = "repo-credentials"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
    string_data = {
      "url" = var.repo_url
      "type" = "helm"
      "sshPrivateKey" = var.ssh_private_key
    }
  }
}

resource "helm_release" "agro-cd" {
  name = "agro-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  create_namespace = true
  skip_crds = true
  # TODO Set version.
}
