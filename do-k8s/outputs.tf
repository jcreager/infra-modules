output "k8s_host" {
  value = digitalocean_kubernetes_cluster.do_k8s.endpoint
}

output "kube_config" {
 sensitive = true 
 value = digitalocean_kubernetes_cluster.do_k8s.kube_config[0]
}
