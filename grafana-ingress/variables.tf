variable "site_name" {}
variable "site_hostname" {}
variable "static_ip" {
  description = "Ingress global static IP name."
  type = string
}
variable "ip_whitelist" {
  description = "A comma separated list of CIDRs or IPs."
  type = string
}
