terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.50.0"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.58"
    }
  }
}
