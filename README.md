<!-- BEGIN_TF_DOCS -->
![CrowdStrike Registration terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# AWS Falcon Cloud Security Terraform Module

This Terraform module enables registration and configuration of AWS accounts with CrowdStrike's Falcon Cloud Security. It supports multi-region deployments and provides flexibility in AWS provider configuration.

For simplified deployment, two specialized sub-modules are available:
- [modules/registration-profile](./modules/registration-profile/README.md) - Streamlined deployment using AWS CLI profiles
- [modules/registration-role](./modules/registration-role/README.md) - Streamlined deployment using cross-account IAM roles

Key features:
- Asset Inventory
- Real-time Visibility and Detection
- Identity Protection (IDP)
- Sensor Management
- Data Security Posture Management (DSPM)

> **Note:** For multi-region deployments, this module needs to be instantiated separately for each region where FCS components are required. The sub-modules handle this automatically. See the examples directory for different deployment patterns.

## Pre-requisites

* You will need to provide CrowdStrike API Keys and CrowdStrike cloud region for the installation. It is recommended to establish new API credentials for the installation at https://falcon.crowdstrike.com/support/api-clients-and-keys, minimal required permissions are:

<table>
    <tr>
        <th>Option</th>
        <th>Scope Name</th>
        <th>Permission</th>
    </tr>
    <tr>
        <td rowspan="2">Automated account registration</td>
        <td>CSPM registration</td>
        <td><strong>Read</strong> and <strong>Write</strong></td>
    </tr>
    <tr>
        <td>Cloud security AWS registration</td>
        <td><strong>Read</strong> and <strong>Write</strong></td>
    </tr>
    <tr>
        <td rowspan="3">1-click sensor management</td>
        <td>CSPM sensor management</td>
        <td><strong>Read</strong> and <strong>Write</strong></td>
    </tr>
    <tr>
        <td>Installation tokens</td>
        <td><strong>Read</strong></td>
    </tr>
    <tr>
        <td>Sensor download</td>
        <td><strong>Read</strong></td>
    </tr>
    <tr>
        <td>DSPM</td>
        <td>DSPM Data scanner</td>
        <td><strong>Read</strong> and <strong>Write</strong></td>
    </tr>
</table>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | >= 0.0.16 |
## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Account type can be either 'commercial' or 'gov' | `string` | `"commercial"` | no |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_dspm_integration_role_unique_id"></a> [dspm\_integration\_role\_unique\_id](#input\_dspm\_integration\_role\_unique\_id) | The unique ID of the DSPM integration role | `string` | `""` | no |
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The regions in which DSPM scanning environments will be created | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that DSPM will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_dspm_scanner_role_name"></a> [dspm\_scanner\_role\_name](#input\_dspm\_scanner\_role\_name) | The unique name of the IAM role that CrowdStrike Scanner will be assuming | `string` | `"CrowdStrikeDSPMScannerRole"` | no |
| <a name="input_dspm_scanner_role_unique_id"></a> [dspm\_scanner\_role\_unique\_id](#input\_dspm\_scanner\_role\_unique\_id) | The unique ID of the DSPM scanner role | `string` | `""` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Set to true to enable Data Security Posture Managment | `bool` | `false` | no |
| <a name="input_enable_idp"></a> [enable\_idp](#input\_enable\_idp) | Set to true to install Identity Protection resources | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to install realtime visibility resources | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | Set to true to install 1Click Sensor Management resources | `bool` | n/a | yes |
| <a name="input_eventbridge_role_name"></a> [eventbridge\_role\_name](#input\_eventbridge\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_eventbus_arn"></a> [eventbus\_arn](#input\_eventbus\_arn) | Eventbus ARN to send events to | `string` | `""` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | The external ID used to assume the AWS reader role | `string` | `""` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the reader role | `string` | `""` | no |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | The intermediate role that is allowed to assume the reader role | `string` | `""` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if you are deploying in gov Falcon | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank if when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm\_regions which controls region-specific resource deployment. | `string` | n/a | yes |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Set to true if you already have a cloudtrail | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_integration_role_unique_id"></a> [integration\_role\_unique\_id](#output\_integration\_role\_unique\_id) | The unique ID of the DSPM integration role |
| <a name="output_scanner_role_unique_id"></a> [scanner\_role\_unique\_id](#output\_scanner\_role\_unique\_id) | The unique ID of the DSPM scanner role |

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
      version = ">= 0.0.16"
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
  provider = crowdstrike
}

module "fcs_account_onboarding" {
  source                     = "CrowdStrike/fcs/aws"
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
module "fcs_account_us-east-2" {
  source                     = "CrowdStrike/fcs/aws"
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


```
<!-- END_TF_DOCS -->