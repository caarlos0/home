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
        container {
          image = "ghcr.io/caarlos0/fastcom-exporter:v1.0.0"
          name  = "exporter"

          args = ["--debug", "--bind=:9877"]

          port {
            container_port = 9877
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9877
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 9877
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
      "prometheus.io/port"   = "9877"
    }
  }
  spec {
    selector = {
      app = "fastcom-exporter"
    }
    port {
      port        = 9877
      target_port = 9877
    }
  }
}
