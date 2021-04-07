resource "helm_release" "influx" {
  name       = "influx"
  namespace  = "influx"
  repository = "https://influxdata.github.io/helm-charts"
  chart      = "influxdb"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/influx.yaml"),
  ]
}
