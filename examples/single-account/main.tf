provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}
provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}
provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}
provider "aws" {
  region = "us-west-1"
  alias  = "us-west-1"
}
provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

locals {
  enable_realtime_visibility  = true
  realtime_visibility_regions = ["all"]
  primary_region              = "us-east-1"
  enable_idp                  = true
  enable_sensor_management    = true
  enable_dspm                 = true
  dspm_regions                = ["us-east-1", "us-east-2"]
  use_existing_cloudtrail     = true

  # customizations
  resource_prefix        = "cs-"
  resource_suffix        = "-cspm"
  custom_role_name       = "${local.resource_prefix}reader-role${local.resource_suffix}"
  dspm_role_name         = "${local.resource_prefix}dspm-integration${local.resource_suffix}"
  dspm_scanner_role_name = "${local.resource_prefix}dspm-scanner${local.resource_suffix}"
  eventbridge_role_name  = "${local.resource_prefix}eventbridge-role${local.resource_suffix}"

  tags = {
    DeployedBy = var.me
    Product    = "FalconCloudSecurity"
  }
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id = var.account_id

  asset_inventory = {
    enabled   = true
    role_name = local.custom_role_name
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
    enabled   = local.enable_dspm
    role_name = local.dspm_role_name
  }
  provider = crowdstrike
}

module "fcs_account_onboarding" {
  source                     = "../../"
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  create_rtvd_rules          = contains(local.realtime_visibility_regions, "all") || contains(local.realtime_visibility_regions, "us-east-1")
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-east-1")
  dspm_regions               = local.dspm_regions
  dspm_scanner_role_name     = local.dspm_scanner_role_name
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  eventbridge_role_name  = local.eventbridge_role_name
  dspm_role_name         = crowdstrike_cloud_aws_account.this.dspm_role_name
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  resource_prefix = local.resource_prefix
  resource_suffix = local.resource_suffix
  tags            = local.tags

  providers = {
    aws         = aws.us-east-1
    crowdstrike = crowdstrike
  }
}

module "fcs_account_us_east_2" {
  source                     = "../.."
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  create_rtvd_rules          = contains(local.realtime_visibility_regions, "all") || contains(local.realtime_visibility_regions, "us-east-2")
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-east-2")
  dspm_regions               = local.dspm_regions
  dspm_scanner_role_name     = local.dspm_scanner_role_name
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name                   = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id                     = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn           = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn                    = crowdstrike_cloud_aws_account.this.eventbus_arn
  eventbridge_role_name           = local.eventbridge_role_name
  dspm_role_name                  = crowdstrike_cloud_aws_account.this.dspm_role_name
  cloudtrail_bucket_name          = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  dspm_integration_role_unique_id = module.fcs_account_onboarding.integration_role_unique_id
  dspm_scanner_role_unique_id     = module.fcs_account_onboarding.scanner_role_unique_id

  resource_prefix = local.resource_prefix
  resource_suffix = local.resource_suffix
  tags            = local.tags

  providers = {
    aws         = aws.us-east-2
    crowdstrike = crowdstrike
  }
}

module "fcs_account_us_west_1" {
  source                     = "../.."
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  create_rtvd_rules          = contains(local.realtime_visibility_regions, "all") || contains(local.realtime_visibility_regions, "us-west-1")
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-west-1")
  dspm_regions               = local.dspm_regions
  dspm_scanner_role_name     = local.dspm_scanner_role_name
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name                   = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id                     = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn           = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn                    = crowdstrike_cloud_aws_account.this.eventbus_arn
  eventbridge_role_name           = local.eventbridge_role_name
  dspm_role_name                  = crowdstrike_cloud_aws_account.this.dspm_role_name
  cloudtrail_bucket_name          = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  dspm_integration_role_unique_id = module.fcs_account_onboarding.integration_role_unique_id
  dspm_scanner_role_unique_id     = module.fcs_account_onboarding.scanner_role_unique_id

  resource_prefix = local.resource_prefix
  resource_suffix = local.resource_suffix
  tags            = local.tags

  providers = {
    aws         = aws.us-west-1
    crowdstrike = crowdstrike
  }
}

module "fcs_account_us_west_2" {
  source                     = "../.."
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  create_rtvd_rules          = contains(local.realtime_visibility_regions, "all") || contains(local.realtime_visibility_regions, "us-west-2")
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-west-2")
  dspm_regions               = local.dspm_regions
  dspm_scanner_role_name     = local.dspm_scanner_role_name
  vpc_cidr_block              = var.vpc_cidr_block

  iam_role_name                   = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id                     = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn           = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn                    = crowdstrike_cloud_aws_account.this.eventbus_arn
  eventbridge_role_name           = local.eventbridge_role_name
  dspm_role_name                  = crowdstrike_cloud_aws_account.this.dspm_role_name
  cloudtrail_bucket_name          = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name
  dspm_integration_role_unique_id = module.fcs_account_onboarding.integration_role_unique_id
  dspm_scanner_role_unique_id     = module.fcs_account_onboarding.scanner_role_unique_id

  resource_prefix = local.resource_prefix
  resource_suffix = local.resource_suffix
  tags            = local.tags

  providers = {
    aws         = aws.us-west-2
    crowdstrike = crowdstrike
  }
}
