provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_config_map" "ingress_nginx" {
  metadata {
    name      = "grafana-dashboards-ingress-nginx-1"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "app-status.json" = file("./dashboars/kubernetes-ingress-nginx_rev2.json")
  }
}
