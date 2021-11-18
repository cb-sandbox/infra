terraform {
  backend "gcs" {
    bucket = "sandbox_bucket"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 4.0.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}
