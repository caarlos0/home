resource "helm_release" "influx" {
  name      = "influx"
  namespace = "influx"
  chart     = "influxdata/influxdb"
  version   = "4.10.2"

  wait             = false
  create_namespace = true

  values = [
    file("files/values/influx.yaml"),
  ]
}
