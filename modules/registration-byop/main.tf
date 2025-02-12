data "aws_region" "current" {}

data "crowdstrike_cloud_aws_accounts" "target" {
  account_id      = var.account_id
  organization_id = length(var.account_id) != 0 ? null : var.organization_id
}

locals {
  # if we target by account_id, it will be the only account returned
  # if we target by organization_id, we pick the first one because all accounts will have the same settings
  account = try(data.crowdstrike_cloud_aws_accounts.target.accounts[0])

  external_id           = local.account.external_id
  intermediate_role_arn = local.account.intermediate_role_arn
  iam_role_arn          = local.account.iam_role_arn
  is_primary_region     = data.aws_region.current.name == var.primary_region
  eventbus_arn          = local.account.eventbus_arn
}

module "asset_inventory" {
  source = "../asset-inventory/"

  external_id           = local.external_id
  intermediate_role_arn = local.intermediate_role_arn
  role_name             = split("/", local.iam_role_arn)[1]
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

module "realtime_visibility_main" {
  count  = (var.is_primary_region) ? 1 : 0
  source = "../realtime-visibility/main/"

  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.account.cloudtrail_bucket_name

  providers = {
    aws = aws
  }
}

module "realtime_visibility_rules" {
  source = "../realtime-visibility/rules/"

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  depends_on = [
    module.realtime_visibility_main
  ]

  providers = {
    aws = aws
  }
}
