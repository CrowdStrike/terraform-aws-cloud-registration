locals {
  # account_id    = data.aws_caller_identity.current.account_id
  # aws_partition = data.aws_partition.current.partition
}

locals {
  # Uncomment regions to exclude from IOA Provisioning (EventBridge Rules).  This will be useful if your organization leverages SCPs to deny specific regions.
  excluded_regions = [
    # "us-east-1",
    # "us-east-2",
    # "us-west-1",
    # "us-west-2",
    # "af-south-1",
    # "ap-east-1",
    # "ap-south-1",
    # "ap-south-2",
    # "ap-southeast-1",
    # "ap-southeast-2",
    # "ap-southeast-3",
    # "ap-southeast-4",
    # "ap-northeast-1",
    # "ap-northeast-2",
    # "ap-northeast-3",
    # "ca-central-1",
    # "eu-central-1",
    # "eu-west-1",
    # "eu-west-2",
    # "eu-west-3",
    # "eu-south-1",
    # "eu-south-2",
    # "eu-north-1",
    # "eu-central-2",
    # "me-south-1",
    # "me-central-1",
    # "sa-east-1"
  ]
}

data "crowdstrike_cloud_aws_accounts" "target" {
  # account_id      = var.account_id
  # organization_id = length(var.account_id) != 0 ? null : var.organization_id
  organization_id = var.organization_id
}

locals {
  # if we target by account_id, it will be the only account returned
  # if we target by organization_id, we pick the first one because all accounts will have the same settings
  account = try(data.crowdstrike_cloud_aws_accounts.target.accounts[0])
}

module "crowdstrike_asset_inventory" {
  source = "./modules/asset-inventory/"

  external_id           = var.external_id
  intermediate_role_arn = local.account.intermediate_role_arn
  role_name             = split("/", local.account.iam_role_arn)[1]
  permissions_boundary  = var.permissions_boundary

  providers = {
    aws = aws
  }
}

module "crowdstrike_realtime_visibility" {
  count  = var.enable_realtime_visibility || var.enable_idp ? 1 : 0
  source = "./modules/realtime-visibility/"

  use_existing_cloudtrail = var.use_existing_cloudtrail
  cloudtrail_bucket_name  = local.account.cloudtrail_bucket_name
  eventbus_arn            = local.account.eventbus_arn
  excluded_regions        = local.excluded_regions
  is_gov                  = false
  is_commercial           = local.account.account_type == "commercial"

  providers = {
    aws = aws

    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
    aws.af-south-1     = aws.af-south-1
    aws.ap-east-1      = aws.ap-east-1
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-south-2     = aws.ap-south-2
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ap-southeast-3 = aws.ap-southeast-3
    aws.ap-southeast-4 = aws.ap-southeast-4
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-northeast-3 = aws.ap-northeast-3
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.eu-south-1     = aws.eu-south-1
    aws.eu-south-2     = aws.eu-south-2
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-central-2   = aws.eu-central-2
    aws.me-south-1     = aws.me-south-1
    aws.me-central-1   = aws.me-central-1
    aws.sa-east-1      = aws.sa-east-1
  }
}

module "crowdstrike_sensor_management" {
  count                 = var.enable_sensor_management ? 1 : 0
  source                = "./modules/sensor-management"
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  external_id           = local.account.external_id
  intermediate_role_arn = local.account.intermediate_role_arn
  permissions_boundary  = var.permissions_boundary

  providers = {
    aws = aws
  }
}
