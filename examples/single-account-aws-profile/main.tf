locals {
  enable_realtime_visibility = true
  primary_region             = "us-west-1"
  enable_idp                 = true
  enable_sensor_management   = false
  enable_dspm                = false
  dspm_regions               = ["us-west-1"]
  use_existing_cloudtrail    = true

  # customizations
  resource_prefix        = "cs-"
  resource_suffix        = "-cspm"
  custom_role_name       = "${local.resource_prefix}reader-role${local.resource_suffix}"
  dspm_role_name         = "${local.resource_prefix}dspm-integration${local.resource_suffix}"
  dspm_scanner_role_name = "${local.resource_prefix}dspm-scanner${local.resource_suffix}"
  eventbridge_role_name  = "${local.resource_prefix}eventbridge-role${local.resource_suffix}"
  tags = {
    DeployedBy = var.me
    Product    = "FalconCloudSecurity"
  }
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id = var.account_id

  asset_inventory = {
    enabled   = true
    role_name = local.custom_role_name
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
    enabled   = local.enable_dspm
    role_name = local.dspm_role_name
  }
  provider = crowdstrike
}

module "fcs_account" {
  source                      = "../../modules/aws-profile"
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
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  eventbridge_role_name  = local.eventbridge_role_name
  dspm_role_name         = crowdstrike_cloud_aws_account.this.dspm_role_name
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  dspm_scanner_role_name = local.dspm_scanner_role_name

  resource_prefix = local.resource_prefix
  resource_suffix = local.resource_suffix
  tags            = local.tags

  providers = {
    crowdstrike = crowdstrike
  }
}
