module "dev_tools_jenkins" {
  source = "./module"

  cluster_type             = module.dev_cluster.platform.type_code
  cluster_ingress_hostname = module.dev_cluster.platform.ingress
  cluster_config_file      = module.dev_cluster.platform.kubeconfig
  tls_secret_name          = module.dev_cluster.platform.tls_secret
  server_url               = module.dev_cluster.platform.server_url
  tools_namespace          = module.dev_capture_state.namespace
}
