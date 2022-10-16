variable "site_name" {}
variable "site_hostname" {}
variable "refers_to" {}
variable "redirect_to" {}
variable "static_ip" {
  description = "Ingress global static IP name."
  type = string
}
