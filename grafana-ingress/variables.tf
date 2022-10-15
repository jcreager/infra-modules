variable "site_name" {}
variable "site_hostname" {}
variable "ip_whitelist" {
  description = "A comma separated list of CIDRs or IPs."
  type = string
}
