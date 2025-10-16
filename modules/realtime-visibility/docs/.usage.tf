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

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "realtime_visibility" {
  source = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility/"

  use_existing_cloudtrail = true
  cloudtrail_bucket_name  = data.crowdstrike_cloud_aws_account.target.accounts[0].cloudtrail_bucket_name

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us_east_1" {
  source               = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility-rules"
  eventbus_arn         = data.crowdstrike_cloud_aws_account.target.accounts[0].eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main[0].eventbridge_role_arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us_east_2" {
  source               = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility-rules"
  eventbus_arn         = data.crowdstrike_cloud_aws_account.target.accounts[0].eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main[0].eventbridge_role_arn

  providers = {
    aws = aws.us-east-2
  }
}
