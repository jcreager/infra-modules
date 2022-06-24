output "k8s_host" {
  value = digital_ocean_kubernetes_cluster.do_k8s.endoint
}

output "kube_config" {
 value = digital_ocean_kubernetes_cluster.do_k8s.kube_config[0]
}
