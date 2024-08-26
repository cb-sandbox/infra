variable "cluster_name" {
  type = string
}

variable "project" {
  type = string
  description = "The GCP cluster name"
}

variable "location" {
  type = string
  description = "The GCP location (zone or region) where the cluster lives"
}

variable "ci_hostname" {
  type = string
}

variable "cluster_issuer" {
  type = string
  default = "letsencrypt-prod"
}