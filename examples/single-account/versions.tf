terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.19"
    }
  }
}
