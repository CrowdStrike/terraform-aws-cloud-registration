terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.19"
    }
  }
}

variable "falcon_client_id" {
  type        = string
  sensitive   = true
  description = "Falcon API Client ID"
}

variable "falcon_client_secret" {
  type        = string
  sensitive   = true
  description = "Falcon API Client Secret"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS 12 digit account ID"
  validation {
    condition     = length(var.account_id) == 0 || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be either empty or the 12-digit AWS account ID"
  }
}

locals {
  enable_realtime_visibility = true
  primary_region             = "us-east-1"
  enable_idp                 = true
  enable_sensor_management   = true
  enable_dspm                = true
  dspm_regions               = ["us-east-1", "us-east-2"]
  use_existing_cloudtrail    = true
}

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
}

module "fcs_account_onboarding" {
  source                     = "CrowdStrike/cloud-registration/aws"
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-east-1")
  dspm_regions               = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {
    aws         = aws.us-east-1
    crowdstrike = crowdstrike
  }
}

# for each region where you want to onboard Real-time Visibility or DSPM features
# - duplicate this module
# - update the provider with region specific one
module "fcs_account_us_east_2" {
  source                     = "CrowdStrike/cloud-registration/aws"
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  primary_region             = local.primary_region
  enable_sensor_management   = local.enable_sensor_management
  enable_realtime_visibility = local.enable_realtime_visibility
  enable_idp                 = local.enable_idp
  use_existing_cloudtrail    = local.use_existing_cloudtrail
  enable_dspm                = local.enable_dspm && contains(local.dspm_regions, "us-east-2")
  dspm_regions               = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {
    aws         = aws.us-east-2
    crowdstrike = crowdstrike
  }
}
