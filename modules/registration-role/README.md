<!-- BEGIN_TF_DOCS -->
![CrowdStrike Registration with cross account role terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | >= 0.0.16 |
## Resources

| Name | Type |
|------|------|
| [aws_regions.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | n/a | yes |
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Account type can be either 'commercial' or 'gov' | `string` | `"commercial"` | no |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_cross_account_role_name"></a> [cross\_account\_role\_name](#input\_cross\_account\_role\_name) | The name of the IAM role used for cross account role switching | `string` | n/a | yes |
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The regions in which DSPM scanning environments will be created | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that DSPM will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_dspm_scanner_role_name"></a> [dspm\_scanner\_role\_name](#input\_dspm\_scanner\_role\_name) | The unique name of the IAM role that CrowdStrike Scanner will be assuming | `string` | `"CrowdStrikeDSPMScannerRole"` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Set to true to enable Data Security Posture Managment | `bool` | `false` | no |
| <a name="input_enable_idp"></a> [enable\_idp](#input\_enable\_idp) | Set to true to install Identity Protection resources | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to install realtime visibility resources | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | Set to true to install 1Click Sensor Management resources | `bool` | n/a | yes |
| <a name="input_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#input\_eventbridge\_role\_arn) | Eventbridge role ARN | `string` | `""` | no |
| <a name="input_eventbus_arn"></a> [eventbus\_arn](#input\_eventbus\_arn) | Eventbus ARN to send events to | `string` | `""` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | The external ID used to assume the AWS reader role | `string` | `""` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the reader role | `string` | `""` | no |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | The intermediate role that is allowed to assume the reader role | `string` | `""` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if registering in gov-cloud | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank if when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm\_regions which controls region-specific resource deployment. | `string` | n/a | yes |
| <a name="input_realtime_visibility_regions"></a> [realtime\_visibility\_regions](#input\_realtime\_visibility\_regions) | The list of regions to onboard Realtime Visibility monitoring. Use ["all"] to onboard all available regions | `list(string)` | `[]` | no |
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

locals {
  management_account_id      = "<your aws account id>"
  organization_id            = "<your aws organization id>"
  cross_account_role_name    = "<your aws cross account role>"
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

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id                         = local.management_account_id
  organization_id                    = local.organization_id
  is_organization_management_account = true

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

module "fcs_management_account" {
  source                      = "CrowdStrike/fcs/aws//modules/registration-role"
  cross_account_role_name     = local.cross_account_role_name
  account_id                  = local.management_account_id
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = local.use_existing_cloudtrail
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = crowdstrike_cloud_aws_account.this.cloudtrail_bucket_name

  providers = {
    crowdstrike = crowdstrike
  }
}

# for each child account you want to onboard
# - duplicate this module
# - replace `account_id` with the correct AWS account id
# - replace `cross_account_role_name` if needed
module "fcs_child_account_1" {
  source                      = "CrowdStrike/fcs/aws//modules/registration-role"
  cross_account_role_name     = local.cross_account_role_name
  account_id                  = "<child account id>"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = true # use the cloudtrail at the org level
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_name          = crowdstrike_cloud_aws_account.this.iam_role_name
  external_id            = crowdstrike_cloud_aws_account.this.external_id
  intermediate_role_arn  = crowdstrike_cloud_aws_account.this.intermediate_role_arn
  eventbus_arn           = crowdstrike_cloud_aws_account.this.eventbus_arn
  cloudtrail_bucket_name = "" # not needed for child accounts

  providers = {
    crowdstrike = crowdstrike
  }
}
```
<!-- END_TF_DOCS -->