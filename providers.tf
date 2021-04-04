provider "kubernetes" {
  config_path = "~/.kube/home"
  host        = "https://192.168.0.134:6443"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/home"
    host        = "https://192.168.0.134:6443"
  }
}
