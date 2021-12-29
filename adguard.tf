resource "kubernetes_stateful_set" "adguard" {
  metadata {
    name      = "adguard"
    namespace = "default"

    labels = {
      app = "adguard"
    }
  }

  spec {
    pod_management_policy  = "Parallel"
    replicas               = 1
    revision_history_limit = 5

    selector {
      match_labels = {
        app = "adguard"
      }
    }

    service_name = "adguard"

    template {
      metadata {
        labels = {
          app = "adguard"
        }
        annotations = {
          "config/md5" = filemd5("files/adguard/config.yaml")
        }
      }

      spec {
        # service_account_name = "adguard"
        host_network = true

        node_selector = {
          "kubernetes.io/hostname" = "pi4"
        }

        volume {
          name = "adguard-config-ro"
          config_map {
            name = "adguard"
          }
        }

        init_container {
          name              = "cp-config"
          image             = "alpine:3.15.0"
          image_pull_policy = "IfNotPresent"
          command           = ["cp", "/config/AdGuardHome.yaml", "/volume/AdGuardHome.yaml"]

          volume_mount {
            mount_path = "/config"
            name       = "adguard-config-ro"
          }

          volume_mount {
            mount_path = "/volume"
            name       = "adguard-config"
          }
        }

        container {
          name              = "adguard"
          image             = "adguard/adguardhome:v0.107.2"
          image_pull_policy = "IfNotPresent"

          liveness_probe {
            exec {
              command = [
                "/bin/sh",
                "-c",
                "nslookup probe 127.0.0.1 &> /dev/null; echo ok",
              ]
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = [
                "/bin/sh",
                "-c",
                "nslookup probe 127.0.0.1 &> /dev/null; echo ok",
              ]
            }

            initial_delay_seconds = 1
            timeout_seconds       = 5
          }

          security_context {
            privileged = true
            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
          }

          volume_mount {
            name       = "adguard-config"
            mount_path = "/opt/adguardhome/conf"
          }

          volume_mount {
            name       = "adguard-data"
            mount_path = "/opt/adguardhome/work/data"
          }
        }

        termination_grace_period_seconds = 300
      }
    }

    volume_claim_template {
      metadata {
        name = "adguard-config"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "local-path"

        resources {
          requests = {
            storage = "100Mi"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "adguard-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "local-path"

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "adguard" {
  metadata {
    name      = "adguard"
    namespace = "default"

    labels = {
      app = "adguard"
    }
  }
  spec {
    selector = {
      app = "adguard"
    }

    port {
      port        = 3000
      target_port = 3000
    }
  }
}

# TODO: uncomment when next kubernetes provider is out
# resource "kubernetes_ingress" "adguard" {
#   metadata {
#     name      = "adguard"
#     namespace = "default"

#     labels = {
#       app = "adguard"
#     }
#   }

#   spec {
#     backend {
#       service_name = "adguard"
#       service_port = 3000
#     }

#     rule {
#       host = "adguard.homes"
#       http {
#         path {
#           backend {
#             service_name = "adguard"
#             service_port = 3000
#           }

#           path = "/"
#         }
#       }
#     }
#   }
# }

resource "kubernetes_config_map" "adguard" {
  metadata {
    name      = "adguard"
    namespace = "default"

    labels = {
      app = "adguard"
    }
  }

  data = {
    "AdGuardHome.yaml" = file("files/adguard/config.yaml")
  }
}
