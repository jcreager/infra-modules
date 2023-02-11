provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "linkerd_crds" {
  name = "linkerd-crds"
  namespace = "linkderd"
  create_namespace = true
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-crds"
}

resource "helm_release" "linkerd_control_plane" {
  name = "linkerd-control-plane"
  namespace = "linkderd"
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-control-plane"
  set {
    name = "identityTrustAnchorsPEM"
    value = var.ca
  }
  set {
    name = "identity.issuer.tls.crtPEM"
    value = var.crt
  }
  set {
    name = "identity.issuer.tls.keyPEM"
    value = var.key
  }
  depends_on = [
    helm_release.linkerd_crds
  ]
}

resource "helm_release" "linkerd_viz" {
  name = "linkerd-viz"
  namespace = "linkderd"
  repository = "https://helm.linkerd.io/stable"
  chart = "linkerd-viz"
  depends_on = [
    helm_release.linkerd_control_plane
  ]
}
