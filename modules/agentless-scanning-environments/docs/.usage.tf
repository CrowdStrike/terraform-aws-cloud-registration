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

module "agentless_scanning_roles" {
  source                       = "CrowdStrike/cloud-registration/aws//modules/agentless-scanning-roles/"
  agentless_scanning_role_name = data.crowdstrike_cloud_aws_account.target.accounts[0].agentless_scanning_role_name
  intermediate_role_arn        = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  external_id                  = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  falcon_client_id             = var.falcon_client_id
  falcon_client_secret         = var.falcon_client_secret
  agentless_scanning_regions   = ["us-east-1"]
}

module "agentless_scanning_environments" {
  source                     = "CrowdStrike/cloud-registration/aws//modules/agentless-scanning-environments/"
  integration_role_unique_id = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.agentless_scanning_roles[0].scanner_role_unique_id
  depends_on                 = [module.agentless_scanning_roles]
}
