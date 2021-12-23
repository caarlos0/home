resource "kubernetes_cron_job" "deadmanssnitch" {
  metadata {
    name      = "deadmanssnitch"
    namespace = "default"
    labels = {
      "app" = "deadmanssnitch"
    }
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 1
    schedule                      = "0/15 * * * *"
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
              "app" = "deadmanssnitch"
            }
          }
          spec {
            container {
              name  = "deadmanssnitch"
              image = "curlimages/curl:7.80.0"
              args  = ["-sf", "https://nosnch.in/cfe0931ff7"]
            }
          }
        }
      }
    }
  }
}
