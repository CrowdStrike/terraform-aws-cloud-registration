provider "aws" {
  profile = var.aws_profile
  region  = var.primary_region
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "aws_region" "current" {}

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
      external_id            = ""
      intermediate_role_arn  = ""
      iam_role_arn           = ""
      eventbus_arn           = ""
      cloudtrail_bucket_name = ""
    }
  )

  external_id            = coalesce(var.external_id, local.account.external_id)
  intermediate_role_arn  = coalesce(var.intermediate_role_arn, local.account.intermediate_role_arn)
  iam_role_arn           = coalesce(var.iam_role_arn, local.account.iam_role_arn)
  eventbus_arn           = coalesce(var.eventbus_arn, local.account.eventbus_arn)
  cloudtrail_bucket_name = var.use_existing_cloudtrail ? "" : coalesce(var.cloudtrail_bucket_name, local.account.cloudtrail_bucket_name)
}

module "asset_inventory" {
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-asset-inventory.tar.gz"

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
  source                = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-sensor-management.tar.gz"
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
  count  = (var.enable_realtime_visibility || var.enable_idp) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-realtime-visibility.tar.gz"

  use_existing_cloudtrail = var.use_existing_cloudtrail
  is_organization_trail   = length(var.organization_id) > 0
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name

  providers = {
    aws = aws
  }
}

module "dspm-roles" {
  count  = (var.enable_dspm && !var.is_gov) ? 1 : 0
  source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-dspm-roles.tar.gz"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  cs_role_arn = var.intermediate_role_arn
  client_id = var.falcon_client_id
  client_secret = var.falcon_client_secret
  external_id = var.external_id
  dspm_regions = var.dspm_regions
}
