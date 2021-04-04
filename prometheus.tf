resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  wait             = false
  create_namespace = true

  values = [
    "${file("values/prometheus.yaml")}"
  ]
}
