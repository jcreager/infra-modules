provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_config_map" "ingress_nginx" {
  metadata {
    name      = "grafana-dashboards-ingress-nginx-1"

    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "app-status.json" = file("ingress-nginx.json")
  }
}