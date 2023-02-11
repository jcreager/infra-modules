##### Create certs for mTLS

```
step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure

step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 8760h --no-password --insecure \
--ca ca.crt --ca-key ca.key
```

###### terragrunt.hcl

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
