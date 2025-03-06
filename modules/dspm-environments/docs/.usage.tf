terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    crowdstrike = {
      source  = "crowdstrike/crowdstrike"
      version = ">= 0.0.16"
    }
  }
}

provider "aws" {
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "dspm_roles" {
  count                 = (var.is_primary_region && var.enable_dspm) ? 1 : 0
  source                = "CrowdStrike/fcs/aws//modules/dspm-roles/"
  dspm_role_name        = split("/", data.crowdstrike_cloud_aws_account.target.accounts.0.dspm_role_arn)[1]
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts.0.intermediate_role_arn
  external_id           = data.crowdstrike_cloud_aws_account.target.accounts.0.external_id
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  dspm_regions          = ["us-east-1"]
}

module "dspm_environments" {
  count          = var.enable_dspm ? 1 : 0
  source         = "CrowdStrike/fcs/aws//modules/dspm-environments/"
  dspm_role_name = split("/", data.crowdstrike_cloud_aws_account.target.accounts.0.dspm_role_arn)[1]
  region         = "us-east-1"
  providers = {
    aws = aws
  }
  depends_on = [module.dspm_roles]
}

