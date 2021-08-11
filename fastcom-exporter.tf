resource "kubernetes_deployment" "fastcom_exporter" {
  metadata {
    name      = "fastcom-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace
    labels = {
      app = "fastcom-exporter"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "fastcom-exporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "fastcom-exporter"
        }
      }

      spec {
        node_selector = {
          "kubernetes.io/hostname" = "pi4"
        }

        container {
          image = "caarlos0/fastcom-exporter"
          name  = "fastcom-exporter"

          args = ["--debug"]

          port {
            container_port = 9875
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9875
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 9875
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "fastcom_exporter" {
  metadata {
    name      = "fastcom-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace

    labels = {
      app = "fastcom-exporter"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "9875"
    }
  }
  spec {
    selector = {
      app = "fastcom-exporter"
    }
    port {
      port        = 9875
      target_port = 9875
    }
  }
}
