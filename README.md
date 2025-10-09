<!-- BEGIN_TF_DOCS -->

![CrowdStrike Registration terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# AWS Falcon Cloud Security Terraform Module

This Terraform module enables registration and configuration of AWS accounts with CrowdStrike's Falcon Cloud Security.

Key features:

- Asset Inventory
- Real-time Visibility and Detection
- Identity Protection (IDP)
- Sensor Management
- Data Security Posture Management (DSPM)

> [!NOTE]
> For multi-region deployments, this module needs to be instantiated separately for each region where FCS components are required.

## Pre-requisites

### Generate API Keys

CrowdStrike API keys are required to use this module. It is highly recommended that you create a dedicated API client with only the required scopes.

1. In the CrowdStrike console, navigate to **Support and resources** > **API Clients & Keys**. Click **Add new API Client**.
2. Add the required scopes for your deployment:

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

3. Click **Add** to create the API client. The next screen will display the API **CLIENT ID**, **SECRET**, and **BASE URL**. You will need all three for the next step.

   <details><summary>picture</summary>
   <p>

   ![api-client-keys](https://github.com/CrowdStrike/aws-ssm-distributor/blob/main/official-package/assets/api-client-keys.png)

   </p>
   </details>

> [!NOTE]
> This page is only shown once. Make sure you copy **CLIENT ID**, **SECRET**, and **BASE URL** to a secure location.

## Usage

```hcl
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
```

## Providers

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                         | >= 5.0.0  |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider_crowdstrike) | >= 0.0.19 |

## Resources

| Name                                                                                                                                               | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                        | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/CrowdStrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |

## Inputs

| Name                                                                                                                           | Description                                                                                                                                                                                                  | Type           | Default                             | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ----------------------------------- | :------: |
| <a name="input_account_id"></a> [account_id](#input_account_id)                                                                | The AWS 12 digit account ID                                                                                                                                                                                  | `string`       | `""`                                |    no    |
| <a name="input_account_type"></a> [account_type](#input_account_type)                                                          | Account type can be either 'commercial' or 'gov'                                                                                                                                                             | `string`       | `"commercial"`                      |    no    |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail_bucket_name](#input_cloudtrail_bucket_name)                            | Name of the S3 bucket for CloudTrail logs                                                                                                                                                                    | `string`       | `""`                                |    no    |
| <a name="input_create_rtvd_rules"></a> [create_rtvd_rules](#input_create_rtvd_rules)                                           | Set to false if you don't want to enable monitoring in this region                                                                                                                                           | `bool`         | `true`                              |    no    |
| <a name="input_dspm_create_nat_gateway"></a> [dspm_create_nat_gateway](#input_dspm_create_nat_gateway)                         | Set to true to create a NAT Gateway for DSPM scanning environments                                                                                                                                           | `bool`         | `true`                              |    no    |
| <a name="input_dspm_dynamodb_access"></a> [dspm_dynamodb_access](#input_dspm_dynamodb_access)                                  | Apply permissions for DynamoDB table scanning                                                                                                                                                                | `bool`         | `true`                              |    no    |
| <a name="input_dspm_integration_role_unique_id"></a> [dspm_integration_role_unique_id](#input_dspm_integration_role_unique_id) | The unique ID of the DSPM integration role                                                                                                                                                                   | `string`       | `""`                                |    no    |
| <a name="input_dspm_rds_access"></a> [dspm_rds_access](#input_dspm_rds_access)                                                 | Apply permissions for RDS instance scanning                                                                                                                                                                  | `bool`         | `true`                              |    no    |
| <a name="input_dspm_redshift_access"></a> [dspm_redshift_access](#input_dspm_redshift_access)                                  | Apply permissions for Redshift cluster scanning                                                                                                                                                              | `bool`         | `true`                              |    no    |
| <a name="input_dspm_regions"></a> [dspm_regions](#input_dspm_regions)                                                          | The regions in which DSPM scanning environments will be created                                                                                                                                              | `list(string)` | <pre>[<br/> "us-east-1"<br/>]</pre> |    no    |
| <a name="input_dspm_role_name"></a> [dspm_role_name](#input_dspm_role_name)                                                    | The unique name of the IAM role that DSPM will be assuming                                                                                                                                                   | `string`       | `"CrowdStrikeDSPMIntegrationRole"`  |    no    |
| <a name="input_dspm_s3_access"></a> [dspm_s3_access](#input_dspm_s3_access)                                                    | Apply permissions for S3 bucket scanning                                                                                                                                                                     | `bool`         | `true`                              |    no    |
| <a name="input_dspm_scanner_role_name"></a> [dspm_scanner_role_name](#input_dspm_scanner_role_name)                            | The unique name of the IAM role that CrowdStrike Scanner will be assuming                                                                                                                                    | `string`       | `"CrowdStrikeDSPMScannerRole"`      |    no    |
| <a name="input_dspm_scanner_role_unique_id"></a> [dspm_scanner_role_unique_id](#input_dspm_scanner_role_unique_id)             | The unique ID of the DSPM scanner role                                                                                                                                                                       | `string`       | `""`                                |    no    |
| <a name="input_enable_dspm"></a> [enable_dspm](#input_enable_dspm)                                                             | Set to true to enable Data Security Posture Managment                                                                                                                                                        | `bool`         | `false`                             |    no    |
| <a name="input_enable_idp"></a> [enable_idp](#input_enable_idp)                                                                | Set to true to install Identity Protection resources                                                                                                                                                         | `bool`         | `false`                             |    no    |
| <a name="input_enable_realtime_visibility"></a> [enable_realtime_visibility](#input_enable_realtime_visibility)                | Set to true to install realtime visibility resources                                                                                                                                                         | `bool`         | `false`                             |    no    |
| <a name="input_enable_sensor_management"></a> [enable_sensor_management](#input_enable_sensor_management)                      | Set to true to install 1Click Sensor Management resources                                                                                                                                                    | `bool`         | n/a                                 |   yes    |
| <a name="input_eventbridge_role_name"></a> [eventbridge_role_name](#input_eventbridge_role_name)                               | The eventbridge role name                                                                                                                                                                                    | `string`       | `"CrowdStrikeCSPMEventBridge"`      |    no    |
| <a name="input_eventbus_arn"></a> [eventbus_arn](#input_eventbus_arn)                                                          | Eventbus ARN to send events to                                                                                                                                                                               | `string`       | `""`                                |    no    |
| <a name="input_external_id"></a> [external_id](#input_external_id)                                                             | The external ID used to assume the AWS reader role                                                                                                                                                           | `string`       | `""`                                |    no    |
| <a name="input_falcon_client_id"></a> [falcon_client_id](#input_falcon_client_id)                                              | Falcon API Client ID                                                                                                                                                                                         | `string`       | n/a                                 |   yes    |
| <a name="input_falcon_client_secret"></a> [falcon_client_secret](#input_falcon_client_secret)                                  | Falcon API Client Secret                                                                                                                                                                                     | `string`       | n/a                                 |   yes    |
| <a name="input_iam_role_name"></a> [iam_role_name](#input_iam_role_name)                                                       | The name of the reader role                                                                                                                                                                                  | `string`       | `""`                                |    no    |
| <a name="input_intermediate_role_arn"></a> [intermediate_role_arn](#input_intermediate_role_arn)                               | The intermediate role that is allowed to assume the reader role                                                                                                                                              | `string`       | `""`                                |    no    |
| <a name="input_is_gov"></a> [is_gov](#input_is_gov)                                                                            | Set to true if you are deploying in gov Falcon                                                                                                                                                               | `bool`         | `false`                             |    no    |
| <a name="input_organization_id"></a> [organization_id](#input_organization_id)                                                 | The AWS Organization ID. Leave blank if when onboarding single account                                                                                                                                       | `string`       | `""`                                |    no    |
| <a name="input_permissions_boundary"></a> [permissions_boundary](#input_permissions_boundary)                                  | The name of the policy used to set the permissions boundary for IAM roles                                                                                                                                    | `string`       | `""`                                |    no    |
| <a name="input_primary_region"></a> [primary_region](#input_primary_region)                                                    | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm_regions which controls region-specific resource deployment. | `string`       | n/a                                 |   yes    |
| <a name="input_resource_prefix"></a> [resource_prefix](#input_resource_prefix)                                                 | The prefix to be added to all resource names                                                                                                                                                                 | `string`       | `"CrowdStrike"`                     |    no    |
| <a name="input_resource_suffix"></a> [resource_suffix](#input_resource_suffix)                                                 | The suffix to be added to all resource names                                                                                                                                                                 | `string`       | `""`                                |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                  | A map of tags to add to all resources that support tagging                                                                                                                                                   | `map(string)`  | `{}`                                |    no    |
| <a name="input_use_existing_cloudtrail"></a> [use_existing_cloudtrail](#input_use_existing_cloudtrail)                         | Set to true if you already have a cloudtrail                                                                                                                                                                 | `bool`         | `false`                             |    no    |
| <a name="input_use_existing_iam_reader_role"></a> [use_existing_iam_reader_role](#input_use_existing_iam_reader_role)          | Set to true if you want to use an existing IAM role for asset inventory                                                                                                                                      | `bool`         | `false`                             |    no    |
| <a name="input_vpc_cidr_block"></a> [vpc_cidr_block](#input_vpc_cidr_block)                                                    | VPC CIDR block                                                                                                                                                                                               | `string`       | `"10.0.0.0/16"`                     |    no    |

## Outputs

| Name                                                                                                              | Description                                |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| <a name="output_integration_role_unique_id"></a> [integration_role_unique_id](#output_integration_role_unique_id) | The unique ID of the DSPM integration role |
| <a name="output_scanner_role_unique_id"></a> [scanner_role_unique_id](#output_scanner_role_unique_id)             | The unique ID of the DSPM scanner role     |

<!-- END_TF_DOCS -->

heloo
