resource "kubernetes_deployment" "github_releases_exporter" {
  metadata {
    name      = "github-releases-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace
    labels = {
      app = "github_releases_exporter"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "github_releases_exporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "github_releases_exporter"
        }
        annotations = {
          "config/md5" = filemd5("files/github_releases_exporter/releases.yaml")
        }
      }

      spec {
        container {
          image = "ghcr.io/caarlos0/github_releases_exporter:v1.6.0"
          name  = "exporter"

          env_from {
            secret_ref {
              name = "github-releases-exporter"
            }
          }

          args = [
            "--config.file=/etc/github_releases_exporter/releases.yml",
            "--releases.max=10",
            "--refresh.interval=1h",
          ]

          port {
            container_port = 9222
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9222
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 9222
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          volume_mount {
            mount_path = "/etc/github_releases_exporter"
            name       = "config"
          }
        }

        volume {
          name = "config"
          config_map {
            name = "github-releases-exporter"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "github_releases_exporter" {
  metadata {
    name      = "github-releases-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace

    labels = {
      app = "github_releases_exporter"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "9222"
    }
  }
  spec {
    selector = {
      app = "github_releases_exporter"
    }
    port {
      port        = 9222
      target_port = 9222
    }
  }
}

resource "kubernetes_config_map" "github_releases_exporter" {
  metadata {
    name      = "github-releases-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace

    labels = {
      app = "github_releases_exporter"
    }
  }

  data = {
    "releases.yml" = file("files/github_releases_exporter/releases.yaml")
  }
}


resource "kubernetes_secret" "github_releases_exporter" {
  metadata {
    name      = "github-releases-exporter"
    namespace = helm_release.prometheus.metadata.0.namespace

    labels = {
      app = "github_releases_exporter"
    }
  }

  data = {
    GITHUB_TOKEN = var.github_token
  }
}
