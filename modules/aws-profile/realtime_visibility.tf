data "aws_regions" "available" {
  all_regions = true
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

locals {
  target_regions = contains(var.realtime_visibility_regions, "all") ? data.aws_regions.available.names : var.realtime_visibility_regions
}

module "rtvd_us_east_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-east-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-east-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws
  }
}

module "rtvd_us_east_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-east-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-east-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.us-east-2
  }
}

module "rtvd_us_west_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-west-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-west-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.us-west-1
  }
}

module "rtvd_us_west_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-west-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-west-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.us-west-2
  }
}

module "rtvd_af_south_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "af-south-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "af-south-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.af-south-1
  }
}

module "rtvd_ap_east_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-east-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-east-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-east-1
  }
}

module "rtvd_ap_south_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-south-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-south-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-south-1
  }
}

module "rtvd_ap_south_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-south-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-south-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-south-2
  }
}

module "rtvd_ap_southeast_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-southeast-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "rtvd_ap_southeast_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-southeast-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "rtvd_ap_southeast_3" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-3") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-southeast-3"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-southeast-3
  }
}

module "rtvd_ap_southeast_4" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-southeast-4") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-southeast-4"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-southeast-4
  }
}

module "rtvd_ap_northeast_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-northeast-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "rtvd_ap_northeast_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-northeast-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "rtvd_ap_northeast_3" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ap-northeast-3") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ap-northeast-3"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "rtvd_ca_central_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "ca-central-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "ca-central-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.ca-central-1
  }
}

module "rtvd_eu_central_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-central-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-central-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-central-1
  }
}

module "rtvd_eu_west_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-west-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-west-1
  }
}

module "rtvd_eu_west_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-west-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-west-2
  }
}

module "rtvd_eu_west_3" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-west-3") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-west-3"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-west-3
  }
}

module "rtvd_eu_south_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-south-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-south-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-south-1
  }
}

module "rtvd_eu_south_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-south-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-south-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-south-2
  }
}

module "rtvd_eu_north_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-north-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-north-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-north-1
  }
}

module "rtvd_eu_central_2" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "eu-central-2") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "eu-central-2"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.eu-central-2
  }
}

module "rtvd_me_south_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "me-south-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "me-south-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.me-south-1
  }
}

module "rtvd_me_central_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "me-central-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "me-central-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.me-central-1
  }
}

module "rtvd_sa_east_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "sa-east-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "sa-east-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.sa-east-1
  }
}

module "rtvd_us_gov_east_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-gov-east-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-gov-east-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.us-gov-east-1
  }
}

module "rtvd_us_gov_west_1" {
  source                  = "../realtime-visibility/"
  count                   = (var.enable_realtime_visibility || var.enable_idp) && contains(local.target_regions, "us-gov-west-1") ? 1 : 0
  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.cloudtrail_bucket_name
  eventbus_arn            = local.eventbus_arn
  eventbridge_role_name   = var.eventbridge_role_name
  is_organization_trail   = length(var.organization_id) > 0
  is_gov_commercial       = local.is_gov_commercial
  is_primary_region       = var.primary_region == "us-gov-west-1"
  primary_region          = var.primary_region
  falcon_client_id        = var.falcon_client_id
  falcon_client_secret    = var.falcon_client_secret
  permissions_boundary    = var.permissions_boundary

  depends_on = [
    data.crowdstrike_cloud_aws_account.target,
  ]

  providers = {
    aws = aws.us-gov-west-1
  }
}
