variable "site_name" {}
variable "site_hostname" {}
variable "site_extra_hostnames" {
  default = []
  type = list
}
