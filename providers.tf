provider "kubernetes" {
  config_path = "~/.kube/home"
  host        = "https://192.168.68.109:6443"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/home"
    host        = "https://192.168.68.109:6443"
  }
}
