locals {
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
  account_id = var.account_id

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
  provider = crowdstrike
}

module "fcs_account" {
  source                      = "CrowdStrike/fcs/aws//modules/registration-profile"
  aws_profile                 = var.aws_profile
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  account_id                  = var.account_id
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

  providers = {
    crowdstrike = crowdstrike
  }
}
