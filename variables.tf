variable "twitter_consumer_key" {
  type = string
}

variable "twitter_consumer_secret" {
  type = string
}

variable "twitter_access_token" {
  type = string
}

variable "twitter_access_token_secret" {
  type = string
}

variable "github_token" {
  type = string
}

variable "kubeconfig" {
  default = "kubeconfig"
}

variable "master_ip" {
  default = "192.168.68.110"
}
