terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.18"
    }
  }
}

variable "falcon_client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client ID"
}

variable "falcon_client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}

locals {
  management_account_id      = "<your aws account id>"
  organization_id            = "<your aws organization id>"
  aws_role_name              = "<your aws account role>"
  enable_realtime_visibility = true
  primary_region             = "us-east-1"
  enable_idp                 = true
  enable_sensor_management   = true
  enable_dspm                = true
  dspm_regions               = ["us-east-1", "us-east-2"]
  use_existing_cloudtrail    = true
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id      = local.management_account_id
  organization_id = local.organization_id

  asset_inventory = {
    enabled = true
  }

  realtime_visibility = {
    enabled                 = local.enable_realtime_visibility
    cloudtrail_region       = local.primary_region
    use_existing_cloudtrail = local.use_existing_cloudtrail
  }

  idp = {
    enabled = local.enable_idp
  }

  sensor_management = {
    enabled = local.enable_sensor_management
  }

  dspm = {
    enabled = local.enable_dspm
  }
}

module "fcs_management_account" {
  source                      = "CrowdStrike/cloud-registration/aws//modules/aws-role"
  aws_role_name               = local.aws_role_name
  account_id                  = local.management_account_id
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = local.use_existing_cloudtrail
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
}

# for each child account you want to onboard
# - duplicate this module
# - replace `account_id` with the correct AWS account id
# - replace `aws_role_name` if needed
module "fcs_child_account_1" {
  source                      = "CrowdStrike/cloud-registration/aws//modules/aws-role"
  aws_role_name               = local.aws_role_name
  account_id                  = "<child account id>"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = true # use the cloudtrail at the org level
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = "" # not needed for child accounts
}
