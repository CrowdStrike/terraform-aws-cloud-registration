terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45"
    }
    crowdstrike = {
      source = "crowdstrike/crowdstrike"
      # version = ">= 0.1.1"
    }
  }
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}


# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id                         = var.account_id
  organization_id                    = var.organization_id
  target_ous                         = var.organizational_unit_ids
  is_organization_management_account = var.organization_id != null && var.organization_id != "" ? true : false

  asset_inventory = {
    enabled   = true
    role_name = var.custom_role_name
  }

  realtime_visibility = {
    enabled           = var.enable_realtime_visibility
    cloudtrail_region = var.aws_region
  }

  idp = {
    enabled = var.enable_idp
  }

  sensor_management = {
    enabled = var.enable_sensor_management
  }

  dspm = {
    enabled   = var.enable_dspm
    role_name = var.dspm_custom_role
  }
  provider = crowdstrike
}

# Bring your own role
module "fcs_management_acct" {
  source = "../../../cs-aws-integration-terraform/modules/registration-role/"

  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  aws_role_arn               = "arn:aws:iam::<accountID>:role/<role_name>"
  sts_region                 = "us-east-1"
  organization_id            = var.organization_id
  permissions_boundary       = var.permissions_boundary
  primary_region             = var.aws_region
  is_gov                     = var.is_gov
  enable_sensor_management   = var.enable_sensor_management
  enable_realtime_visibility = var.enable_realtime_visibility
  enable_idp                 = var.enable_idp
  use_existing_cloudtrail    = var.use_existing_cloudtrail
  iam_role_arn               = crowdstrike_cloud_aws_account.this.iam_role_arn
  external_id                = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn      = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn               = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name     = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {
    crowdstrike = crowdstrike
  }
}

module "fcs_child_acct" {
  source = "../../../cs-aws-integration-terraform/modules/registration-role/"

  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  aws_role_arn               = "arn:aws:iam::<accountID>:role/<role_name>"
  sts_region                 = "us-east-1"
  organization_id            = var.organization_id
  permissions_boundary       = var.permissions_boundary
  primary_region             = var.aws_region
  is_gov                     = var.is_gov
  enable_sensor_management   = var.enable_sensor_management
  enable_realtime_visibility = var.enable_realtime_visibility
  enable_idp                 = var.enable_idp
  use_existing_cloudtrail    = true # use the cloudtrail at the org level
  cloudtrail_bucket_name     = ""   # not needed for child accounts
  iam_role_arn               = crowdstrike_cloud_aws_account.this.iam_role_arn
  external_id                = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn      = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn               = crowdstrike_cloud_aws_account.this.eventbus_arn

  providers = {
    crowdstrike = crowdstrike
  }
}
