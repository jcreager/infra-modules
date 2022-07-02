provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "certmanager" {
  skip_crds = false
  name = "cert-manager"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus-blackbox-exporter"
  create_namespace = true
}

resource "kubernetes_secret" "scrape_configs" {
  metadata {
    name = "scrape-configs"
  }

  data = {
    "scrape-configs.yaml" = var.scrape_configs
  }

  type = "Opaque"
}
