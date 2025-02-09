provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  # Uncomment regions to exclude from IOA Provisioning (EventBridge Rules).  This will be useful if your organization leverages SCPs to deny specific regions.
  excluded_regions = [
    # "us-east-1",
    # "us-east-2",
    # "us-west-1",
    # "us-west-2",
    # "af-south-1",
    # "ap-east-1",
    # "ap-south-1",
    # "ap-south-2",
    # "ap-southeast-1",
    # "ap-southeast-2",
    # "ap-southeast-3",
    # "ap-southeast-4",
    # "ap-northeast-1",
    # "ap-northeast-2",
    # "ap-northeast-3",
    # "ca-central-1",
    # "eu-central-1",
    # "eu-west-1",
    # "eu-west-2",
    # "eu-west-3",
    # "eu-south-1",
    # "eu-south-2",
    # "eu-north-1",
    # "eu-central-2",
    # "me-south-1",
    # "me-central-1",
    # "sa-east-1"
  ]
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id                         = data.aws_caller_identity.current.account_id
  organization_id                    = var.organization_id
  target_ous                         = var.organizational_unit_ids
  is_organization_management_account = var.organization_id != null && var.organization_id != "" ? true : false
  account_type                       = "commercial"
  asset_inventory = {
    enabled   = true
    role_name = var.custom_role_name
  }
  realtime_visibility = {
    enabled           = var.enable_realtime_visibility
    cloudtrail_region = var.aws_region
  }
  idp = {
    enabled = var.enable_idp
  }
  sensor_management = {
    enabled = var.enable_sensor_management
  }
  dspm = {
    enabled   = var.enable_dspm
    role_name = var.dspm_role_name
    regions = var.dspm_regions
  }
}

module "crowdstrike_asset_inventory" {
  source = "./modules/asset-inventory/"

  external_id           = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  role_name             = split("/", crowdstrike_cloud_aws_account.this.iam_role_arn)[1]
  permissions_boundary  = var.permissions_boundary

  providers = {
    aws = aws
  }
}

module "crowdstrike_realtime_visibility" {
  count  = var.enable_realtime_visibility || var.enable_idp ? 1 : 0
  source = "./modules/realtime-visibility/"

  aws_profile             = var.aws_profile
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  eventbus_arn            = crowdstrike_cloud_aws_account.this.eventbus_arn
  excluded_regions        = local.excluded_regions
  is_gov                  = false
  is_commercial           = crowdstrike_cloud_aws_account.this.account_type == "commercial"

  providers = {
    aws = aws

    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
    aws.af-south-1     = aws.af-south-1
    aws.ap-east-1      = aws.ap-east-1
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-south-2     = aws.ap-south-2
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ap-southeast-3 = aws.ap-southeast-3
    aws.ap-southeast-4 = aws.ap-southeast-4
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-northeast-3 = aws.ap-northeast-3
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.eu-south-1     = aws.eu-south-1
    aws.eu-south-2     = aws.eu-south-2
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-central-2   = aws.eu-central-2
    aws.me-south-1     = aws.me-south-1
    aws.me-central-1   = aws.me-central-1
    aws.sa-east-1      = aws.sa-east-1
  }
}

module "crowdstrike_sensor_management" {
  count                    = var.enable_sensor_management ? 1 : 0
  source                   = "./modules/sensor-management"
  client_id                = var.falcon_client_id
  client_secret            = var.falcon_client_secret
  external_id              = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn    = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  credentials_storage_mode = var.credentials_storage_mode
  permissions_boundary     = var.permissions_boundary
}

module "dspm" {
  count = var.enable_dspm ? 1 : 0
  source = "./modules/dspm"
  client_id                = var.falcon_client_id
  client_secret            = var.falcon_client_secret
  external_id           = crowdstrike_cloud_aws_account.this.external_id
  cs_role_arn = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  dspm_role_name = crowdstrike_cloud_aws_account.this.dspm.role_name
  region = var.aws_region
  dspm_regions = crowdstrike_cloud_aws_account.this.dspm.regions
  aws_profile             = var.aws_profile
  providers = {
    aws = aws

    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
    aws.af-south-1     = aws.af-south-1
    aws.ap-east-1      = aws.ap-east-1
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-south-2     = aws.ap-south-2
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ap-southeast-3 = aws.ap-southeast-3
    aws.ap-southeast-4 = aws.ap-southeast-4
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-northeast-3 = aws.ap-northeast-3
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.eu-south-1     = aws.eu-south-1
    aws.eu-south-2     = aws.eu-south-2
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-central-2   = aws.eu-central-2
    aws.me-south-1     = aws.me-south-1
    aws.me-central-1   = aws.me-central-1
    aws.sa-east-1      = aws.sa-east-1
  }
}
