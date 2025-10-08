terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.19"
    }
  }
}

provider "aws" {}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "dspm_roles" {
  source                = "CrowdStrike/cloud-registration/aws//modules/dspm-roles/"
  dspm_role_name        = data.crowdstrike_cloud_aws_account.target.accounts[0].dspm_role_arn
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  external_id           = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  dspm_regions          = ["us-east-1"]
}

module "dspm_environments" {
  source         = "CrowdStrike/cloud-registration/aws//modules/dspm-environments/"
  dspm_role_name = data.crowdstrike_cloud_aws_account.target.accounts[0].dspm_role_arn
  region         = "us-east-1"
  depends_on     = [module.dspm_roles]
}
