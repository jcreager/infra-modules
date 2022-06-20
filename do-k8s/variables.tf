variable "do_token" {
  default = ""
}

variable "environment" {}

variable "vpc_name" {
  default = "vpc-${environment}"
}

variable "region" {
  default = "sfo2"
}

variable "k8s_name" {
  default = "k8s-${environment}"
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
