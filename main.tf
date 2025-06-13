data "aws_region" "current" {}

data "crowdstrike_cloud_aws_account" "target" {
  account_id      = var.account_id
  organization_id = length(var.account_id) != 0 ? null : var.organization_id
}

locals {
  aws_region        = data.aws_region.current.name
  is_primary_region = local.aws_region == var.primary_region

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
  count                        = local.is_primary_region ? 1 : 0
  source                       = "./modules/asset-inventory/"
  external_id                  = local.external_id
  intermediate_role_arn        = local.intermediate_role_arn
  role_name                    = local.iam_role_name
  permissions_boundary         = var.permissions_boundary
  use_existing_iam_reader_role = var.use_existing_iam_reader_role
  tags                         = var.tags

  depends_on = [
    data.crowdstrike_cloud_aws_account.target
  ]

}

module "sensor_management" {
  count                 = (local.is_primary_region && var.enable_sensor_management) ? 1 : 0
  source                = "./modules/sensor-management/"
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  external_id           = local.external_id
  intermediate_role_arn = local.intermediate_role_arn
  permissions_boundary  = var.permissions_boundary
  resource_prefix       = var.resource_prefix
  resource_suffix       = var.resource_suffix
  tags                  = var.tags

  depends_on = [
    data.crowdstrike_cloud_aws_account.target
  ]

  providers = {
    aws = aws
  }
}

module "realtime_visibility" {
  count                   = (var.enable_realtime_visibility || var.enable_idp) ? 1 : 0
  source                  = "./modules/realtime-visibility/"
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbridge_role_name   = var.eventbridge_role_name
  eventbus_arn            = local.eventbus_arn
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = var.is_gov && var.account_type == "commercial"
  is_primary_region       = local.is_primary_region
  create_rules            = var.create_rtvd_rules
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  resource_prefix         = var.resource_prefix
  resource_suffix         = var.resource_suffix
  tags                    = var.tags

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws
  }
}

module "dspm_roles" {
  count                  = (local.is_primary_region && var.enable_dspm) ? 1 : 0
  source                 = "./modules/dspm-roles/"
  falcon_client_id       = var.falcon_client_id
  falcon_client_secret   = var.falcon_client_secret
  dspm_role_name         = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  intermediate_role_arn  = local.intermediate_role_arn
  external_id            = local.external_id
  dspm_regions           = var.dspm_regions
  tags                   = var.tags
}

module "dspm_environments" {
  count                      = var.enable_dspm && contains(var.dspm_regions, local.aws_region) ? 1 : 0
  source                     = "./modules/dspm-environments/"
  dspm_role_name             = var.dspm_role_name
  integration_role_unique_id = local.is_primary_region ? module.dspm_roles[0].integration_role_unique_id : var.dspm_integration_role_unique_id
  scanner_role_unique_id     = local.is_primary_region ? module.dspm_roles[0].scanner_role_unique_id : var.dspm_scanner_role_unique_id
  tags                       = var.tags

  depends_on = [module.dspm_roles]

  providers = {
    aws = aws
  }
}
