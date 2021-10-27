resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "14.11.0"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/prometheus.yaml"),
  ]
}
