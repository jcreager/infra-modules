variable "client_url" {
  description = "URL for Loki client."
  default = "http://loki.default.svc.cluster.local:3100/loki/api/v1/push"
  type = string
}
