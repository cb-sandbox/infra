terraform {
  #   backend "gcs" {
  #     bucket = "sandbox_bucket"
  #     prefix = "terraform/state"
  #   }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
