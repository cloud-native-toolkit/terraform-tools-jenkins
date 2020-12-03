# Jenkins terraform module

![Latest release](https://img.shields.io/github/v/release/ibm-garage-cloud/terraform-tools-jenkins?sort=semver) ![Verify and release module](https://github.com/ibm-garage-cloud/terraform-tools-jenkins/workflows/Verify%20and%20release%20module/badge.svg)

Installs Jenkins into the cluster

## Software dependencies

The module depends on the following software components:

- terraform v12
- kubectl
- helm terraform provider >= 1.1.1 (provided by terraform provider)

## Module dependencies

- Cluster
- Namespace

## Example usage

```hcl-terraform
module "dev_tools_jenkins" {
  source = "github.com/ibm-garage-cloud/terraform-tools-jenkins.git?ref=v1.1.0"

  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  cluster_type             = module.dev_cluster.type_code
  tls_secret_name          = module.dev_cluster.tls_secret_name
  server_url               = module.dev_cluster.server_url
  tools_namespace          = module.dev_cluster_namespaces.tools_namespace_name
}
```
