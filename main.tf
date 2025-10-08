data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "crowdstrike_cloud_aws_account" "target" {
  account_id      = var.account_id
  organization_id = length(var.account_id) != 0 ? null : var.organization_id
}

locals {
  aws_region        = data.aws_region.current.name
  aws_account       = data.aws_caller_identity.current.account_id
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

module "agentless_scanning_roles" {
  count                                       = (local.is_primary_region && (var.enable_dspm || var.enable_vulnerability_scanning)) ? 1 : 0
  source                                      = "./modules/agentless-scanning-roles/"
  falcon_client_id                            = var.falcon_client_id
  falcon_client_secret                        = var.falcon_client_secret
  dspm_role_name                              = var.dspm_role_name
  dspm_scanner_role_name                      = var.dspm_scanner_role_name
  intermediate_role_arn                       = local.intermediate_role_arn
  external_id                                 = local.external_id
  dspm_regions                                = var.dspm_regions
  agentless_scanning_use_custom_vpc           = var.agentless_scanning_use_custom_vpc
  agentless_scanning_custom_vpc_resources_map = var.agentless_scanning_custom_vpc_resources_map
  dspm_s3_access                              = var.dspm_s3_access
  dspm_dynamodb_access                        = var.dspm_dynamodb_access
  dspm_rds_access                             = var.dspm_rds_access
  dspm_redshift_access                        = var.dspm_redshift_access
  enable_dspm                                 = var.enable_dspm
  enable_vulnerability_scanning               = var.enable_vulnerability_scanning
  tags                                        = var.tags
  account_id                                  = local.aws_account
  agentless_scanning_host_account_id          = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name           = var.agentless_scanning_host_role_name
  agentless_scanning_host_scanner_role_name   = var.agentless_scanning_host_scanner_role_name
}

module "agentless_scanning_environments" {
  count                              = (var.enable_dspm || var.enable_vulnerability_scanning) && contains(var.dspm_regions, local.aws_region) ? 1 : 0
  source                             = "./modules/agentless-scanning-environments/"
  dspm_role_name                     = var.dspm_role_name
  dspm_scanner_role_name             = var.dspm_scanner_role_name
  integration_role_unique_id         = local.is_primary_region ? module.agentless_scanning_roles[0].integration_role_unique_id : var.dspm_integration_role_unique_id
  scanner_role_unique_id             = local.is_primary_region ? module.agentless_scanning_roles[0].scanner_role_unique_id : var.dspm_scanner_role_unique_id
  dspm_create_nat_gateway            = var.dspm_create_nat_gateway
  account_id                         = local.aws_account
  agentless_scanning_host_account_id = var.agentless_scanning_host_account_id
  agentless_scanning_host_role_name  = var.agentless_scanning_host_role_name

  # Pass explicit boolean decision and region-specific VPC config
  use_custom_vpc    = var.agentless_scanning_use_custom_vpc
  region_vpc_config = var.agentless_scanning_use_custom_vpc ? lookup(var.agentless_scanning_custom_vpc_resources_map, local.aws_region, null) : null

  tags           = var.tags
  vpc_cidr_block = var.vpc_cidr_block

  depends_on = [module.agentless_scanning_roles]

  providers = {
    aws = aws
  }
}

# Handle module renames
moved {
  from = module.dspm_roles
  to   = module.agentless_scanning_roles
}

moved {
  from = module.dspm_environments
  to   = module.agentless_scanning_environments
}
