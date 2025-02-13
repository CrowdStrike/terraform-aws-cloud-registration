provider "aws" {
  assume_role {
    role_arn = var.aws_role_arn
  }
  region = var.primary_region
}
data "aws_region" "current" {}

data "crowdstrike_cloud_aws_accounts" "target" {
  account_id      = var.account_id
  organization_id = length(var.account_id) != 0 ? null : var.organization_id
}

locals {
  # if we target by account_id, it will be the only account returned
  # if we target by organization_id, we pick the first one because all accounts will have the same settings
  account = try(
    data.crowdstrike_cloud_aws_accounts.target.accounts[0],
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
  count  = (var.enable_realtime_visibility || var.enable_idp) ? 1 : 0
  source = "../realtime-visibility/main/"

  use_existing_cloudtrail = var.use_existing_cloudtrail
  is_organization_trail   = length(var.organization_id) > 0
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  role_name               = "crowdstrike-event-bridge"

  providers = {
    aws = aws
  }
}

data "aws_regions" "available" {
  all_regions = true
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

locals {
  available_regions = [for region in data.aws_regions.available.names : region if !contains(var.excluded_regions, region)]
}

module "rules_us-east-1" {
  source = "../realtime-visibility/rules/"

  count                = contains(local.available_regions, "us-east-1") && !var.is_gov ? 1 : 0
  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us-east-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "us-east-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-east-2
  }
}

module "rules_us-west-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "us-west-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-west-1
  }
}

module "rules_us-west-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "us-west-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-west-2
  }
}

module "rules_af-south-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "af-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.af-south-1
  }
}

module "rules_ap-east-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-east-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-east-1
  }
}

module "rules_ap-south-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-south-1
  }
}

module "rules_ap-south-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-south-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-south-2
  }
}

module "rules_ap-southeast-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-southeast-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "rules_ap-southeast-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-southeast-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "rules_ap-southeast-3" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-southeast-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-3
  }
}

module "rules_ap-southeast-4" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-southeast-4") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-southeast-4
  }
}

module "rules_ap-northeast-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-northeast-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "rules_ap-northeast-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-northeast-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "rules_ap-northeast-3" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ap-northeast-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "rules_ca-central-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "ca-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.ca-central-1
  }
}

module "rules_eu-central-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-central-1
  }
}

module "rules_eu-west-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-west-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-west-1
  }
}

module "rules_eu-west-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-west-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-west-2
  }
}

module "rules_eu-west-3" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-west-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-west-3
  }
}

module "rules_eu-south-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-south-1
  }
}

module "rules_eu-south-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-south-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-south-2
  }
}

module "rules_eu-north-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-north-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-north-1
  }
}

module "rules_eu-central-2" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "eu-central-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.eu-central-2
  }
}

module "rules_me-south-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "me-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.me-south-1
  }
}

module "rules_me-central-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "me-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.me-central-1
  }
}
module "rules_sa-east-1" {
  source = "../realtime-visibility/rules/"
  count  = contains(local.available_regions, "sa-east-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = local.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.sa-east-1
  }
}

