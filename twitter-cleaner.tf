resource "kubernetes_cron_job" "twitter_cleaner" {
  metadata {
    name      = "twitter-cleaner"
    namespace = "default"
    labels = {
      "app" = "twitter-cleaner"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "1 0 * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 1
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {
            labels = {
              "app" = "twitter-cleaner"
            }
          }
          spec {
            container {
              name  = "twitter-cleaner"
              image = "ghcr.io/caarlos0/twitter-cleaner:latest"
              args = [
                "--debug",
                "--max-age=168h",
                "--keep=goreleaser",
                "--keep=charm",
                "--keep=carlosbecker.com",
                "--keep=caarlos0.dev",
                "--keep=carlosbecker.dev",
                "--keep=github.com/caarlos0",
                "--keep=1433157814415941640",
                "--keep=1460595005391880193",
              ]

              env_from {
                secret_ref {
                  name = "twitter-cleaner"
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "twitter_cleaner" {
  metadata {
    name      = "twitter-cleaner"
    namespace = "default"
  }

  data = {
    TWITTER_CONSUMER_KEY        = var.twitter_consumer_key
    TWITTER_CONSUMER_SECRET     = var.twitter_consumer_secret
    TWITTER_ACCESS_TOKEN        = var.twitter_access_token
    TWITTER_ACCESS_TOKEN_SECRET = var.twitter_access_token_secret
  }
}
