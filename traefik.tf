resource "helm_release" "traefik" {
  name      = "traefik"
  namespace = "kube-system"
  chart     = "traefik/traefik"
  wait      = false
}
