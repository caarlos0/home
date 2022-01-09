resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = "prometheus"
  chart     = "grafana/grafana"
  version   = "6.20.3"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/grafana.yaml"),
  ]
}
