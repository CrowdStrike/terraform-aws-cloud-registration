locals {
  enable_realtime_visibility = true
  primary_region             = "us-east-1"
  enable_idp                 = true
  enable_sensor_management   = true
  enable_dspm                = true
  dspm_regions               = ["us-east-1", "us-east-2"]
  use_existing_cloudtrail    = true
  dspm_create_nat_gateway    = var.dspm_create_nat_gateway
  dspm_s3_access             = var.dspm_s3_access
  dspm_dynamodb_access       = var.dspm_dynamodb_access
  dspm_rds_access            = var.dspm_rds_access
  dspm_redshift_access       = var.dspm_redshift_access
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id      = var.account_id
  organization_id = var.organization_id

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
  source                      = "../../modules/aws-profile/"
  aws_profile                 = "797120160429_AdministratorAccess"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  account_id                  = var.account_id
  organization_id             = var.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = local.use_existing_cloudtrail
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name           = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id             = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn   = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn            = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name  = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  dspm_create_nat_gateway = local.dspm_create_nat_gateway
  dspm_s3_access          = local.dspm_s3_access
  dspm_dynamodb_access    = local.dspm_dynamodb_access
  dspm_rds_access         = local.dspm_rds_access
  dspm_redshift_access    = local.dspm_redshift_access
}

# for each child account you want to onboard
# - duplicate this module
# - replace `aws_profile` with the correct profile for your child account
module "fcs_child_account_1" {
  source                      = "../../modules/aws-profile/"
  aws_profile                 = "260362687268_AdministratorAccess"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = true # use the cloudtrail at the org level
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name           = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id             = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn   = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn            = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name  = "" # not needed for child accounts
  dspm_create_nat_gateway = local.dspm_create_nat_gateway
  dspm_s3_access          = local.dspm_s3_access
  dspm_dynamodb_access    = local.dspm_dynamodb_access
  dspm_rds_access         = local.dspm_rds_access
  dspm_redshift_access    = local.dspm_redshift_access
  agentless_scanning_host_account_id   = var.account_id
  dspm_integration_role_unique_id = module.fcs_management_account.integration_role_unique_id
  dspm_scanner_role_unique_id = module.fcs_management_account.scanner_role_unique_id
}
