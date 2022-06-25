provider "digitalocean" {}

terraform {
  backend "s3" {}
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_vpc" "do_vpc" {
  name   = var.vpc_name
  region = var.region
}

data "digitalocean_kubernetes_versions" "do_versions" {
  version_prefix = var.version_prefix
}

resource "digitalocean_kubernetes_cluster" "do_k8s" {
  name    = var.k8s_name
  region  = var.region
  version = data.digitalocean_kubernetes_versions.do_versions.latest_version
  vpc_uuid = digitalocean_vpc.do_vpc.id

  maintenance_policy {
    start_time  = "04:00"
    day         = "tuesday"
  }

  node_pool {
    name       = "autoscale-worker-pool"
    size       = var.node_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
  }
}

resource "digitalocean_project" "do_project" {
  name = var.project_name
  description = var.project_description
  purpose = var.project_purpose
  environment = var.environment
  resources = [digitalocean_kubernetes_cluster.do_k8s.urn]
}
