data "aws_caller_identity" "current" {}

locals {
  aws_partition     = var.account_type == "gov" ? "aws-us-gov" : "aws"
  is_gov_commercial = var.is_gov && var.account_type == "commercial"
  account_role_arn  = "arn:${local.aws_partition}:iam::${var.account_id}:role/${var.aws_role_name}"
  aws_account       = data.aws_caller_identity.current.account_id
}

provider "aws" {
  assume_role {
    role_arn     = local.account_role_arn
    session_name = "TerraformSession"
  }
  region                      = var.primary_region
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  sts_region                  = var.primary_region
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id      = var.account_id
  organization_id = length(var.account_id) != 0 ? null : var.organization_id
}

locals {
  # if we target by account_id, it will be the only account returned
  # if we target by organization_id, we pick the first one because all accounts will have the same settings
  account = try(
    data.crowdstrike_cloud_aws_account.target.accounts[0],
    {
      account_id             = ""
      external_id            = ""
      intermediate_role_arn  = ""
      iam_role_name          = ""
      eventbus_arn           = ""
      cloudtrail_bucket_name = ""
    }
  )

  external_id            = coalesce(var.external_id, local.account.external_id)
  intermediate_role_arn  = coalesce(var.intermediate_role_arn, local.account.intermediate_role_arn)
  iam_role_name          = coalesce(var.iam_role_name, local.account.iam_role_name)
  eventbus_arn           = coalesce(var.eventbus_arn, local.account.eventbus_arn)
  cloudtrail_bucket_name = var.use_existing_cloudtrail ? "" : coalesce(var.cloudtrail_bucket_name, local.account.cloudtrail_bucket_name)
}

module "asset_inventory" {
  source                       = "../asset-inventory/"
  external_id                  = local.external_id
  intermediate_role_arn        = local.intermediate_role_arn
  role_name                    = local.iam_role_name
  use_existing_iam_reader_role = var.use_existing_iam_reader_role
  permissions_boundary         = var.permissions_boundary
  tags                         = var.tags

  providers = {
    aws = aws
  }
}

module "sensor_management" {
  count                 = var.enable_sensor_management ? 1 : 0
  source                = "../sensor-management/"
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  external_id           = local.external_id
  intermediate_role_arn = local.intermediate_role_arn
  permissions_boundary  = var.permissions_boundary
  resource_prefix       = var.resource_prefix
  resource_suffix       = var.resource_suffix
  tags                  = var.tags

  providers = {
    aws = aws
  }

}
module "agentless_scanning_roles" {
  count                                       = ((var.enable_dspm || var.enable_vulnerability_scanning) && !var.is_gov) ? 1 : 0
  source                                      = "../agentless-scanning-roles/"
  falcon_client_id                            = var.falcon_client_id
  falcon_client_secret                        = var.falcon_client_secret
  account_id                                  = local.aws_account
  dspm_role_name                              = var.dspm_role_name
  dspm_scanner_role_name                      = var.dspm_scanner_role_name
  intermediate_role_arn                       = local.intermediate_role_arn
  external_id                                 = local.external_id
  dspm_regions                                = var.dspm_regions
  agentless_scanning_use_custom_vpc           = var.agentless_scanning_use_custom_vpc
  agentless_scanning_custom_vpc_resources_map = var.agentless_scanning_custom_vpc_resources_map
  agentless_scanning_host_account_id          = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name           = var.agentless_scanning_host_role_name
  agentless_scanning_host_scanner_role_name   = var.agentless_scanning_host_scanner_role_name
  dspm_s3_access                              = var.dspm_s3_access
  dspm_dynamodb_access                        = var.dspm_dynamodb_access
  dspm_rds_access                             = var.dspm_rds_access
  dspm_redshift_access                        = var.dspm_redshift_access
  enable_dspm                                 = var.enable_dspm
  enable_vulnerability_scanning               = var.enable_vulnerability_scanning
  tags                                        = var.tags
}

moved {
  from = module.dspm_roles
  to   = module.agentless_scanning_roles
}
