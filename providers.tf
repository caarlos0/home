provider "kubernetes" {
  config_path = var.kubeconfig
  host        = "https://${var.master_ip}:6443"
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
    host        = "https://${var.master_ip}:6443"
  }
}
