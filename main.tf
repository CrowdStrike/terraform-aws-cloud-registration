provider "crowdstrike" {
  client_id     = var.client_id
  client_secret = var.client_secret
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "aws_caller_identity" "current" {}

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

  providers = {
    aws = aws
  }
}

