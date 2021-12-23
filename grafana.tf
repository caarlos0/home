resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "prometheus"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "6.20.3"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/grafana.yaml"),
  ]
}
