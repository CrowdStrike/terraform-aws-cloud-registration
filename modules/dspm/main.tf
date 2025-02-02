terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.aws_profile
}

data "aws_caller_identity" "current" {}

module "crowdstrike-aws-dspm-roles" {
  source = "./crowdstrike-aws-dspm-roles"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  cs_account_number = var.cs_account_number
  cs_role_name = var.cs_role_name
  client_id = var.client_id
  client_secret = var.client_secret
  external_id = var.external_id
}
