provider "crowdstrike" {
  client_id     = var.client_id
  client_secret = var.client_secret
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
resource "crowdstrike_cspm_aws_account" "account" {
  account_id                         = data.aws_caller_identity.current.account_id
  organization_id                    = var.organization_id
  target_ous                         = var.organizational_unit_ids
  is_organization_management_account = var.organization_id != null && var.organization_id != "" ? true : false
  cloudtrail_region                  = var.aws_region
  enable_realtime_visibility         = var.enable_realtime_visibility
  enable_sensor_management           = var.enable_sensor_management
  enable_dspm                        = var.enable_dspm
  dspm_role_name                     = var.dspm_role_name
}

module "crowdstrike_asset_inventory" {
  source = "./modules/asset-inventory/"

  external_id           = crowdstrike_cspm_aws_account.account.external_id
  intermediate_role_arn = crowdstrike_cspm_aws_account.account.intermediate_role_arn
  role_name             = split("/", crowdstrike_cspm_aws_account.account.iam_role_arn)[1]
  permissions_boundary  = var.permissions_boundary

  providers = {
    aws = aws
  }
}

module "crowdstrike_realtime_visibility" {
  # count  = var.behavior_assessment_enabled ? 1 : 0
  source = "./modules/realtime-visibility/"

  profile                 = var.aws_profile
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = crowdstrike_cspm_aws_account.account.cloudtrail_bucket_name
  eventbus_arn            = crowdstrike_cspm_aws_account.account.eventbus_arn
  excluded_regions        = local.excluded_regions
  is_gov                  = false

  providers = {
    aws = aws
  }
}

module "crowdstrike_sensor_management" {
  count                    = var.enable_sensor_management ? 1 : 0
  source                   = "./modules/sensor-management"
  client_id                = var.client_id
  client_secret            = var.client_secret
  external_id              = crowdstrike_cspm_aws_account.account.external_id
  intermediate_role_arn    = crowdstrike_cspm_aws_account.account.intermediate_role_arn
  credentials_storage_mode = var.credentials_storage_mode
  permissions_boundary     = var.permissions_boundary
}
