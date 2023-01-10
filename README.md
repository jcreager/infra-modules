# About

This repository is a collection of modules intended to be consumed by Terragrunt.  Terragrunt is a wrapper for Terraform that reduces some of the boilerplate of Terraform and makes it easy to produce modules which can share data without `terraform_remote_state`.  The repository is semantically versioned as a whole, however, the modules are intended to be pluggable and standalone.

##### Disclaimer

My current workflow for consuming these modules is far from perfect and there are aspects of how these modules are designed that reflect this.  In particular, I don't have a good solution for automatically setting the kube-context after creating the Kubernetes cluster and before applying the Kubernetes modules.  So, if you are strictly following my modules rather than using them as a template for your own, you will need to either get clever or create the Kubernetes cluster and deploy the Kubernetes modules in two separate steps.

I also can't claim that any of the implementations contained in this repository are best practices.  Think of this repository as a starting place and a personal sandbox for ideas.  This is alpha status and I make no claims as to the future stability of this collection of libraries.

Finally, to my knowledge any code that is not my own original work in this repository is derived from permissively licensed works.  However, I have not maintained an active record of potential licenses.


## Why Terragrunt?

In a nutshell, Terragrunt is appealing because it makes creating reproducable environments via Terraform with a single command practical.  The worst Terraform implementations I have seen were sprawling masses of copy and pasted boilerplate between "environments".  Creating a new environment was always an arduous task in these circumstances.  Propagating changes to greater environments was equally toilsome.

## How to use the modules in this repository

Think of this repository as a collection of modules that you will consume in your own project and think of git as the package manager.  Create a new repository which represents the desired state of your infrastructure and consumes these modules (or your own).  In that new repository, perhaps called infra-live, you should setup your Terraform backends.

What should the "live" repo look like?

```
<environment>
  - terragrunt.hcl <-- top level config in project root
  - <module>
    - terragrunt.hcl <-- module config
```

### Setting up the backend

Create a file called `terragrunt.hcl` in the root of your "live" repository which creates the backend.  Change the CHANGEMEs.  This example assumes you will deploy to DigitalOcean using DO spaces.

```
generate "backend" {
  path = "s3_backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    access_key = "CHANGEME"
    secret_key = "CHANGEME"
    endpoint = "https://sfo3.digitaloceanspaces.com"
    region = "CHANGEME"
    bucket = "CHANGEME"
    key = "${path_relative_to_include()}/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check = true
  }
}
EOF
}
```

### Consuming the modules

```
terraform {
  source = "git@github.com:jcreager/infra-modules.git//do-k8s?ref=v0.0.10"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "my-vpc-prd"
  k8s_name = "my-k8s-prd"
  project_name = "k8s-prd"
  project_description = "Production Kubernetes Cluster."
  project_purpose = "Production instaces of k8s deployments."
}
```

### Deploying

In your "live" repository, run the command that follows.

```
terragrunt run-all apply
```

### Development Tips

Did you know that you can point to a branch or commit hash instead of a git tag when consuming modules?  If you are working on a module of your own consider using something like `ref=development` in the `source` URL and use the flag `terragrunt-source-update` when running `terragrunt apply`.
