terraform {
  backend "s3" {
    bucket  = "terraform-remote-state"
    region  = "ap-south-1"
    key     = "dev-infra"
    profile = "dev"
  }
}

provider "aws" {
  region = ap-south-1"
  default_tags {
    tags = {
      service                = var.service
      environment            = var.environment
      owner                  = var.owner
      infrastructure_version = var.infrastructure_version
      ait                    = var.ait
      github_repository_name = var.github_repository_name
    }
  }
}

# Datasource block to get the default VPC information.
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "terraform-remote-state"
    region  = "ap-south-1"
    key     = "dev-vpc"
    profile = "dev"
  }
}

#Get account ID for each AWS account.
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "app_2-infra" {
  backend = "s3"

  config = {
    bucket  = "terraform-remote-state"
    region  = "ap-south-1"
    key     = "deve-app_2-infra"
    profile = "dev"
  }
}

data "terraform_remote_state" "app_3-infra" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-axiamed-staging-us-west-2"
    region  = "us-west-2"
    key     = "dev-app_3-infra"
    profile = "dev"
  }
}