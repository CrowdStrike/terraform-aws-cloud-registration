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

# Configure your povider the way you know
provider "aws" {
}

data "aws_region" "current" {
}

locals {
  is_primary_region = var.aws_region == data.aws_region.current.name
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  count                              = local.is_primary_region ? 1 : 0
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


module "fcs_onboard" {
  source                     = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-registration-provider.tar.gz"
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = var.account_id
  organization_id            = var.organization_id
  permissions_boundary       = var.permissions_boundary
  primary_region             = var.aws_region
  is_primary_region          = local.is_primary_region
  enable_sensor_management   = var.enable_sensor_management
  enable_realtime_visibility = var.enable_realtime_visibility

  depends_on = [
    crowdstrike_cloud_aws_account.this
  ]

  providers = {
    aws         = aws
    crowdstrike = crowdstrike
  }
}

