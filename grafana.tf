resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "prometheus"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/grafana.yaml"),
  ]
}
