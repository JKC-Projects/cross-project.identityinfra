terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }

  # set TF CLI version
  required_version = "~> 1.1"

  # use Terraform Cloud as state backend
  cloud {
    organization = "jkc-projects"
    workspaces {
      tags = ["identityinfra"]
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      project     = "smalldomains"
      managed_by  = "terraform"
      github_repo = "smalldomains.identityinfra"
    }
  }
}

data "aws_region" "current" {}