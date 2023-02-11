```
terraform {
  source = "git@github.com:jcreager/infra-modules.git//linkerd?ref=CHANGEME"
}

include {
  path = find_in_parent_folders()
}

dependency "k8s" {
  config_path = "../do-k8s"
}

inputs = {
  ca = file("ca.crt")
  crt = file("issuer.crt")
  key = file("issuer.key")
}

```
