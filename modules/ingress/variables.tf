variable "wildcard_domain" {
  type        = string
  description = "The base domain/subdomain for this environment."
}

variable "dns_zone" {
  type        = string
  description = "The Cloud DNS zone where the record will be managed."
}

variable "dns_project" {
  type        = string
  description = "GCP Project where the DNS zone lives."
}

variable "email" {
  type = string
  description = "Email for cert-manager"
}

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