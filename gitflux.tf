resource "kubernetes_cron_job" "gitflux_caarlos0_repositories" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux-caarlos0-repositories"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "*/15 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "gitflux"
            }
          }
          spec {
            container {
              name  = "gitflux"
              image = "ghcr.io/caarlos0/gitflux:latest"
              args = [
                "--influx=http://influxdb:8086",
                "--influx-token='admin'",
                "repository",
              ]

              env_from {
                secret_ref {
                  name = "gitflux"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_cron_job" "gitflux_goreleaser_repositories" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux-goreleaser-repositories"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "*/15 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "gitflux"
            }
          }
          spec {
            container {
              name  = "gitflux"
              image = "ghcr.io/caarlos0/gitflux:latest"
              args = [
                "--influx=http://influxdb:8086",
                "--influx-token='admin'",
                "repository",
                "goreleaser",
              ]

              env_from {
                secret_ref {
                  name = "gitflux"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_cron_job" "gitflux_caarlos0_relationships" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux-caarlos0-relationships"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "*/30 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "gitflux"
            }
          }
          spec {
            container {
              name  = "gitflux"
              image = "ghcr.io/caarlos0/gitflux:latest"
              args = [
                "--influx=http://influxdb:8086",
                "--influx-token='admin'",
                "relationships",
              ]

              env_from {
                secret_ref {
                  name = "gitflux"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_cron_job" "gitflux_caarlos0_notifications" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux-caarlos0-notifications"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "*/5 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "gitflux"
            }
          }
          spec {
            container {
              name  = "gitflux"
              image = "ghcr.io/caarlos0/gitflux:latest"
              args = [
                "--influx=http://influxdb:8086",
                "--influx-token='admin'",
                "notifications",
              ]

              env_from {
                secret_ref {
                  name = "gitflux"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_cron_job" "gitflux_caarlos0_sponsors" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux-caarlos0-sponsors"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "*/5 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 1
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "gitflux"
            }
          }
          spec {
            container {
              name  = "gitflux"
              image = "ghcr.io/caarlos0/gitflux:latest"
              args = [
                "--influx=http://influxdb:8086",
                "--influx-token='admin'",
                "sponsors",
              ]

              env_from {
                secret_ref {
                  name = "gitflux"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "gitflux" {
  depends_on = [helm_release.influx]

  metadata {
    name      = "gitflux"
    namespace = "influx"
    labels = {
      "app" = "gitflux"
    }
  }

  data = {
    GITHUB_TOKEN = var.github_token
  }
}
