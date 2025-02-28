terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    crowdstrike = {
      source  = "crowdstrike/crowdstrike"
      version = ">= 0.0.15"
    }
  }
}

locals {
  falcon_client_id           = "<your-falcon-client-id>"
  falcon_client_secret       = "<your-falcon-client-secret>"
  account_id                 = "<your aws account id>"
  enable_realtime_visibility = true
  primary_region             = "us-east-1"
  enable_idp                 = true
  enable_sensor_management   = true
  enable_dspm                = true
  dspm_regions               = ["us-east-1", "us-east-2"]
  use_existing_cloudtrail    = true
}

provider "crowdstrike" {
  client_id     = local.falcon_client_id
  client_secret = local.falcon_client_secret
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


# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id = local.account_id

  asset_inventory = {
    enabled = true
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
    enabled = local.enable_dspm
  }
  provider = crowdstrike
}

module "fcs_account_onboarding" {
  source                     = "CrowdStrike/fcs/aws"
  falcon_client_id           = local.falcon_client_id
  falcon_client_secret       = local.falcon_client_secret
  account_id                 = local.account_id
  is_primary_region          = primary_region == "us-east-1"
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = contains(local.dspm_regions, "us-east-1")
  dspm_regions               = local.dspm_regions

  depends_on = [
    crowdstrike_cloud_aws_account.this
  ]

  providers = {
    aws         = aws.us-east-1
    crowdstrike = crowdstrike
  }
}

# for each region where you want to onboard Real-time Visibility or DSPM features
# - duplicate this module
# - update the provider with region specific one
module "fcs_account_us-east-2" {
  source                     = "CrowdStrike/fcs/aws"
  falcon_client_id           = local.falcon_client_id
  falcon_client_secret       = local.falcon_client_secret
  account_id                 = local.account_id
  is_primary_region          = primary_region == "us-east-2"
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = contains(local.dspm_regions, "us-east-2")
  dspm_regions               = local.dspm_regions

  depends_on = [
    crowdstrike_cloud_aws_account.this
  ]

  providers = {
    aws         = aws.us-east-2
    crowdstrike = crowdstrike
  }
}


