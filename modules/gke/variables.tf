variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "machine_type" {
  type = string
  default = "n1-standard-4"
}

variable "min_node_count" {
  type = number
  default = 1
}

variable "max_node_count" {
  type = number
  default = 5
}

