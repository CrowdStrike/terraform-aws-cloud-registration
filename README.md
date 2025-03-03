<!-- BEGIN_TF_DOCS -->
![CrowdStrike Registration terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# Terraform Modules Documentation

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | >= 0.0.15 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asset_inventory"></a> [asset\_inventory](#module\_asset\_inventory) | ./modules/asset-inventory/ | n/a |
| <a name="module_dspm_environments"></a> [dspm\_environments](#module\_dspm\_environments) | ./modules/dspm-environments/ | n/a |
| <a name="module_dspm_roles"></a> [dspm\_roles](#module\_dspm\_roles) | ./modules/dspm-roles/ | n/a |
| <a name="module_realtime_visibility"></a> [realtime\_visibility](#module\_realtime\_visibility) | ./modules/realtime-visibility/ | n/a |
| <a name="module_realtime_visibility_rules"></a> [realtime\_visibility\_rules](#module\_realtime\_visibility\_rules) | ./modules/realtime-visibility-rules/ | n/a |
| <a name="module_sensor_management"></a> [sensor\_management](#module\_sensor\_management) | ./modules/sensor-management/ | n/a |
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
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Account type can be either 'commercial' or 'gov' | `string` | `"commercial"` | no |
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The regions in which DSPM scanning environments will be created | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that DSPM will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_dspm_scanner_role_name"></a> [dspm\_scanner\_role\_name](#input\_dspm\_scanner\_role\_name) | The unique name of the IAM role that CrowdStrike Scanner will be assuming | `string` | `"CrowdStrikeDSPMScannerRole"` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Set to true to enable Data Security Posture Managment | `bool` | `false` | no |
| <a name="input_enable_idp"></a> [enable\_idp](#input\_enable\_idp) | Set to true to install Identity Protection resources | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to install realtime visibility resources | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | Set to true to install 1Click Sensor Management resources | `bool` | n/a | yes |
| <a name="input_eventbridge_role_name"></a> [eventbridge\_role\_name](#input\_eventbridge\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if you are deploying in gov Falcon | `bool` | `false` | no |
| <a name="input_is_primary_region"></a> [is\_primary\_region](#input\_is\_primary\_region) | The AWS region where resources should be deployed | `bool` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank if when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
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
      source  = "crowdstrike/crowdstrike"
      version = ">= 0.0.15"
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

locals {
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
  provider = crowdstrike
}

module "fcs_account_onboarding" {
  source                     = "CrowdStrike/fcs/aws"
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = local.account_id
  primary_region             = local.primary_region
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
  falcon_client_id           = var.falcon_client_id
  falcon_client_secret       = var.falcon_client_secret
  account_id                 = local.account_id
  primary_region             = local.primary_region
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


```
<!-- END_TF_DOCS -->