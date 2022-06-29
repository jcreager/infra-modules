provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "configmap_monitoring_grafana_dashboards_custom_1" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "app-status.json" = file("./dashboars/kubernetes-ingress-nginx_rev2.json")
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "grafana_dashboard" = "1"
        "prometheus" = "my-value"
        "release" = "prometheus"
      }
      "name" = "grafana-dashboards-custom-1"
      "namespace" = "monitoring"
    }
  }
}
