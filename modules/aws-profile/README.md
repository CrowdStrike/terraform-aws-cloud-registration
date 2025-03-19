<!-- BEGIN_TF_DOCS -->
![CrowdStrike Registration with aws profile terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module allows onboarding multiple aws regions within the same module call, addressing specific challenges in Terraform's native multi-region deployment capabilities. Generally CI/CD pipelines and other orchestration tools are common approaches for multi-region deployments, and are still recommeded over using this module.

The module achieves multi-region deployment by defining provider blocks internally. These `aws` provider blocks will use the provided `aws_prfoile` to authenticate. This design choice does create certain limitations to be aware of; for example, the module is not compatible with Terraform's `for_each`, `count`, and `depends_on` arguments. Your workflow for destroying resources defined in this module will be also be impacted see [Running Terraform Destroy](#Running-Terraform-Destroy). You can learn more about the implications by reading [terraform's documentation](https://developer.hashicorp.com/terraform/language/modules/develop/providers#legacy-shared-modules-with-provider-configurations).

> [!IMPORTANT]
> It is recommeded to use the root module `CrowdStrik/cloud-registration/aws` over this wrapper module.

## Running Terraform Destroy

When working with this module, you need to be aware of a specific behavior related to resource destruction due to how provider blocks are managed internally.

The issue occurs in this specific scenario:

1. You have a module block in your configuration that uses this multi-region module
2. You decide to remove that module block from your configuration
3. You run `terraform apply` expecting Terraform to automatically destroy the resources that were created by the module
4. Instead of destroying resources, you get an error about missing provider configurations

> [!IMPORTANT]
> This issue only occurs when you remove the module block from your configuration. If you're destroying your entire Terraform configuration using terraform destroy, you won't encounter this problem because the provider configurations are still available during the destroy process.

For example, if you remove this module block from your configuration:

```hcl
module "account" {
  source                      = "CrowdStrike/cloud-registration/aws//modules/aws-profile"
  aws_profile                 = var.aws_profile
  falcon_client_id            = var.falcon_client_id
  # Other parameters...
  realtime_visibility_regions = ["us-west-1"]
}
```

And then run `terraform apply`, you'll encounter an error like:

```
Error: Provider configuration not present

To work with module.account.module.rtvd_us_west_1[0].aws_cloudwatch_event_target.ro (orphan) its original provider configuration at
module.account.provider["registry.terraform.io/hashicorp/aws"].us-west-1 is required, but it has been removed. This occurs when a provider
configuration is removed while objects created by that provider still exist in the state. Re-add the provider configuration to destroy
module.account.module.rtvd_us_west_1[0].aws_cloudwatch_event_target.ro (orphan), after which you can remove the provider configuration again.
```

This happens because removing the module block also removes the internal provider configurations that Terraform needs to destroy the resources.

### Solution: Targeted Destruction
Before removing the module from your configuration, destroy the resources using a targeted destroy command:

```
terraform destroy -target="module.account"
```
After the resources are destroyed, you can safely remove the module from your configuration and run terraform apply.

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
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.18"
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
  organization_id            = "<your aws organization id>"
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
  account_id      = var.account_id
  organization_id = local.organization_id

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

module "fcs_management_account" {
  source                      = "CrowdStrike/cloud-registration/aws//modules/aws-profile"
  aws_profile                 = "<aws profile for your management account>"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  account_id                  = var.account_id
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
}

# for each child account you want to onboard
# - duplicate this module
# - replace `aws_profile` with the correct profile for your child account
module "fcs_child_account_1" {
  source                      = "CrowdStrike/cloud-registration/aws//modules/aws-profile"
  aws_profile                 = "<aws profile for this child account>"
  falcon_client_id            = var.falcon_client_id
  falcon_client_secret        = var.falcon_client_secret
  organization_id             = var.organization_id
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
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | >= 0.0.16 |
## Resources

| Name | Type |
|------|------|
| [aws_regions.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/CrowdStrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Account type can be either 'commercial' or 'gov' | `string` | `"commercial"` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to be used for this registration | `string` | n/a | yes |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | Name of the S3 bucket for CloudTrail logs | `string` | `""` | no |
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The regions in which DSPM scanning environments will be created | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that DSPM will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_dspm_scanner_role_name"></a> [dspm\_scanner\_role\_name](#input\_dspm\_scanner\_role\_name) | The unique name of the IAM role that CrowdStrike Scanner will be assuming | `string` | `"CrowdStrikeDSPMScannerRole"` | no |
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
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if your falcon cloud is gov | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm\_regions which controls region-specific resource deployment. | `string` | n/a | yes |
| <a name="input_realtime_visibility_regions"></a> [realtime\_visibility\_regions](#input\_realtime\_visibility\_regions) | The list of regions to onboard Realtime Visibility monitoring. Use ["all"] to onboard all available regions | `list(string)` | `[]` | no |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Set to true if you already have a cloudtrail | `bool` | `false` | no |
## Outputs

No outputs.
<!-- END_TF_DOCS -->
