module "dev_tools_jenkins" {
  source = "./module"

  cluster_type             = module.dev_cluster.type_code
  cluster_ingress_hostname = module.dev_cluster.ingress_hostname
  cluster_config_file      = module.dev_cluster.config_file_path
  tls_secret_name          = module.dev_cluster.tls_secret_name
  server_url               = module.dev_cluster.server_url
  tools_namespace          = module.dev_capture_state.namespace
}
