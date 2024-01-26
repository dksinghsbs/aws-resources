terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
  }
  required_version = "1.7.1"
}