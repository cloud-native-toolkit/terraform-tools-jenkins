provider "null" {
}

provider "helm" {
  version = ">= 1.1.1"
  kubernetes {
    config_path = var.cluster_config_file
  }
}

locals {
  tmp_dir          = "${path.cwd}/.tmp"
  secret_name      = "jenkins-access"
  config_name      = var.cluster_type == "kubernetes" ? "jenkins-config" : "pipeline-config"
  values_file      = "${path.module}/jenkins-values.yaml"
  ingress_host     = "jenkins.${var.cluster_ingress_hostname}"
  ingress_url      = "${var.cluster_type != "kubernetes" ? "https" : "http"}://${local.ingress_host}"
  pipeline_url     = "${var.server_url}/console/projects"
}

resource "helm_release" "jenkins_iks" {
  count = var.cluster_type == "kubernetes" ? 1 : 0

  name         = "jenkins"
  repository   = "https://kubernetes-charts.storage.googleapis.com/"
  chart        = "jenkins"
  version      = var.helm_version
  namespace    = var.tools_namespace
  force_update = true

  values = [
    file(local.values_file)
  ]

  set {
    name  = "master.ingress.hostName"
    value = local.ingress_host
  }

  set {
    name  = "master.ingress.tls[0].secretName"
    value = var.tls_secret_name
  }

  set {
    name  = "master.ingress.tls[0].hosts[0]"
    value = local.ingress_host
  }

  set {
    name = "persistence.storageClass"
    value = var.storage_class
  }
}

resource "helm_release" "jenkins-config_iks" {
  depends_on = [helm_release.jenkins_iks]
  count      = var.cluster_type == "kubernetes" ? 1 : 0

  name         = "jenkins-config"
  chart        = "${path.module}/charts/jenkins-config"
  namespace    = var.tools_namespace
  force_update = true

  set {
    name  = "jenkins.tls"
    value = var.tls_secret_name != "" ? "true" : "false"
  }

  set {
    name  = "jenkins.host"
    value = local.ingress_host
  }
}

resource "null_resource" "wait-for-job" {
  depends_on = [helm_release.jenkins-config_iks]
  count      = var.cluster_type == "kubernetes" ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/waitForJobCompletion.sh ${var.tools_namespace}"

    environment = {
      KUBECONFIG = var.cluster_config_file
    }
  }
}

resource "helm_release" "pipeline-config" {
  count = var.cluster_type != "kubernetes" ? 1 : 0

  name         = "pipeline"
  repository   = "https://ibm-garage-cloud.github.io/toolkit-charts/"
  chart        = "tool-config"
  namespace    = var.tools_namespace
  force_update = true

  set {
    name  = "url"
    value = local.pipeline_url
  }
}
