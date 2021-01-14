variable "project" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "cluster_name" {
  type = string
}

variable "agent_count" {
  type = number
  default = 0
}
