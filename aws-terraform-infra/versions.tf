  
terraform {
  required_version = ">= 0.19.0"

  required_providers {

    aws = {
      source = "hashicorp/aws"
      version = "3.60.0"

    }
    
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}
