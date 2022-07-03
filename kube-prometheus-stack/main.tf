provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~>2.6"
    }
  }
}

resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  create_namespace = true
  skip_crds = true
  values = [
    yamlencode(
      {
        #  "ingress.enabled" = true
        #  "hosts" = [var.grafana_host]
        #  "tls" = [
        #    {
        #      "secretName" = var.tls_secret_name
        #      "hosts" = [var.grafana_host]
        #    }
        #  ]
        #"extraScrapeConfigs" = var.scrape_configs
        "extraScrapeConfigs" = {
          "job_name" = "blackbox"
          "metrics_path" = "/probe"
          "params" = {
            "module" = ["http_2xx"]
          }
          "static_configs" = [{"targets" = var.scrape_targets}]
          "relable_configs" = [
            {
              "source_labels" = ["__address__"]
              "target_labels" = "__param_target"
            },
            {
              "source_labels" = ["__param_target"]
              "target_labels" = "instance"
            },
            {
              "source_labels" = ["__address__"]
              "target_labels" = "blackbox-exporter-prometheus-blackbox-exporter.default.svc.cluster.local:9115"
            }
          ]
        }
      }
    )
  ]
}
