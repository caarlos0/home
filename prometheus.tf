resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "prometheus"
  chart     = "prometheus-community/prometheus"
  version   = "15.0.2"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/prometheus.yaml"),
  ]
}
