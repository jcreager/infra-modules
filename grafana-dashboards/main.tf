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

resource "kubernetes_config_map" "blackbox_exporter" {
  metadata {
    name      = "grafana-dashboards-blackbox-exporter-1"

    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "blackbox-exporter.json" = file("blackbox-exporter.json")
  }
}

resource "kubernetes_config_map" "loki" {
  metadata {
    name      = "grafana-dashboards-loki-1"

    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    "loki.json" = file("kubernetes-service-logs_rev1.json")
  }
}
