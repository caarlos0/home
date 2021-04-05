resource "kubernetes_deployment" "speedtest_exporter" {
  metadata {
    name      = "speedtest-exporter"
    namespace = "prometheus"
    labels = {
      app = "speedtest-exporter"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "speedtest-exporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "speedtest-exporter"
        }
      }

      spec {
        container {
          image = "ghcr.io/caarlos0/speedtest-exporter:v0.1.0"
          name  = "exporter"

          port {
            container_port = 9876
            name           = "metrics"
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9876
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 9876
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "speedtest_exporter" {
  metadata {
    name      = "speedtest-exporter"
    namespace = "prometheus"

    labels = {
      app = "speedtest-exporter"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "9876"
    }
  }
  spec {
    selector = {
      app = "speedtest-exporter"
    }
    port {
      port        = 9876
      target_port = 9876
    }
  }
}
