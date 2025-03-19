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

  is_gov_commercial = var.is_gov && var.account_type == "commercial"
}

module "asset_inventory" {
  source                = "../asset-inventory/"
  external_id           = local.external_id
  intermediate_role_arn = local.intermediate_role_arn
  role_name             = local.iam_role_name
  permissions_boundary  = var.permissions_boundary

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

  providers = {
    aws = aws
  }
}


module "dspm_roles" {
  count                  = (var.enable_dspm && !var.is_gov) ? 1 : 0
  source                 = "../dspm-roles/"
  falcon_client_id       = var.falcon_client_id
  falcon_client_secret   = var.falcon_client_secret
  dspm_role_name         = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  intermediate_role_arn  = local.intermediate_role_arn
  external_id            = local.external_id
  dspm_regions           = var.dspm_regions
}
