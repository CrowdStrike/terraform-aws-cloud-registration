<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# Terraform Modules Documentation

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | n/a |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asset_inventory"></a> [asset\_inventory](#module\_asset\_inventory) | https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-asset-inventory.tar.gz | n/a |
| <a name="module_realtime_visibility"></a> [realtime\_visibility](#module\_realtime\_visibility) | https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-realtime-visibility.tar.gz | n/a |
| <a name="module_realtime_visibility_rules"></a> [realtime\_visibility\_rules](#module\_realtime\_visibility\_rules) | https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-realtime-visibility-rules.tar.gz | n/a |
| <a name="module_sensor_management"></a> [sensor\_management](#module\_sensor\_management) | https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/cs-aws-integration-terraform/0.1.0/cs-aws-integration-terraform-sensor-management.tar.gz | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_dspm_custom_role"></a> [dspm\_custom\_role](#input\_dspm\_custom\_role) | The role ARN used for Data Security Posture Managment integration | `string` | `""` | no |
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The list of regions where DSPM should be enabled | `list(string)` | `[]` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Set to true to enable Data Security Posture Managment | `bool` | `false` | no |
| <a name="input_enable_idp"></a> [enable\_idp](#input\_enable\_idp) | Set to true to install Identity Protection resources | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to install realtime visibility resources | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | Set to true to install 1Click Sensor Management resources | `bool` | n/a | yes |
| <a name="input_eventbridge_role_name"></a> [eventbridge\_role\_name](#input\_eventbridge\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_is_primary_region"></a> [is\_primary\_region](#input\_is\_primary\_region) | The AWS region where resources should be deployed | `bool` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank if when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The AWS region where resources should be deployed | `string` | n/a | yes |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Set to true if you already have a cloudtrail | `bool` | `false` | no |
## Outputs

No outputs.

## Usage

```hcl
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

```
<!-- END_TF_DOCS -->