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
