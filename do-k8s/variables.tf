variable "do_token" {
  default = ""
}

variable "environment" {}

variable "vpc_name" {}

variable "region" {
  default = "sfo2"
}

variable "k8s_name" {}

variable "version_prefix" {
  default = "1.22."
}

variable "node_size" {
  default = "s-2vcpu-4gb"
}

variable "min_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 3
}

variable "project_name" {}

variable "project_description" {}

variable "project_purpose" {}
