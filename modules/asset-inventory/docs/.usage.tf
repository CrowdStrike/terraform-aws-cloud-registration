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

provider "aws" {}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}


module "asset_inventory" {
  source = "CrowdStrike/cloud-registration/aws//modules/asset-inventory"

  external_id           = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  role_name             = data.crowdstrike_cloud_aws_account.target.accounts[0].iam_role_name
  permissions_boundary  = var.permissions_boundary
}
