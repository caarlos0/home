resource "kubernetes_deployment" "speedtest_exporter" {
  metadata {
    name      = "speedtest-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace
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
        node_selector = {
          "kubernetes.io/hostname" = "pi4"
        }

        container {
          image = "caarlos0/speedtest-exporter"
          name  = "speedtest-exporter"

          args = ["--debug"]

          port {
            container_port = 9876
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
    namespace = helm_release.prometheus.metadata.0.namespace

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
