<!-- BEGIN_TF_DOCS -->
![CrowdStrike Registration with AWS profile terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

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
| <a name="module_asset_inventory"></a> [asset\_inventory](#module\_asset\_inventory) | ../asset-inventory/ | n/a |
| <a name="module_dspm-environment-af-south-1"></a> [dspm-environment-af-south-1](#module\_dspm-environment-af-south-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-east-1"></a> [dspm-environment-ap-east-1](#module\_dspm-environment-ap-east-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-northeast-1"></a> [dspm-environment-ap-northeast-1](#module\_dspm-environment-ap-northeast-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-northeast-2"></a> [dspm-environment-ap-northeast-2](#module\_dspm-environment-ap-northeast-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-northeast-3"></a> [dspm-environment-ap-northeast-3](#module\_dspm-environment-ap-northeast-3) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-south-1"></a> [dspm-environment-ap-south-1](#module\_dspm-environment-ap-south-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-south-2"></a> [dspm-environment-ap-south-2](#module\_dspm-environment-ap-south-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-southeast-1"></a> [dspm-environment-ap-southeast-1](#module\_dspm-environment-ap-southeast-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-southeast-2"></a> [dspm-environment-ap-southeast-2](#module\_dspm-environment-ap-southeast-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-southeast-3"></a> [dspm-environment-ap-southeast-3](#module\_dspm-environment-ap-southeast-3) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ap-southeast-4"></a> [dspm-environment-ap-southeast-4](#module\_dspm-environment-ap-southeast-4) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-ca-central-1"></a> [dspm-environment-ca-central-1](#module\_dspm-environment-ca-central-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-central-1"></a> [dspm-environment-eu-central-1](#module\_dspm-environment-eu-central-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-central-2"></a> [dspm-environment-eu-central-2](#module\_dspm-environment-eu-central-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-north-1"></a> [dspm-environment-eu-north-1](#module\_dspm-environment-eu-north-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-south-1"></a> [dspm-environment-eu-south-1](#module\_dspm-environment-eu-south-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-south-2"></a> [dspm-environment-eu-south-2](#module\_dspm-environment-eu-south-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-west-1"></a> [dspm-environment-eu-west-1](#module\_dspm-environment-eu-west-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-west-2"></a> [dspm-environment-eu-west-2](#module\_dspm-environment-eu-west-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-eu-west-3"></a> [dspm-environment-eu-west-3](#module\_dspm-environment-eu-west-3) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-me-central-1"></a> [dspm-environment-me-central-1](#module\_dspm-environment-me-central-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-me-south-1"></a> [dspm-environment-me-south-1](#module\_dspm-environment-me-south-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-sa-east-1"></a> [dspm-environment-sa-east-1](#module\_dspm-environment-sa-east-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-us-east-1"></a> [dspm-environment-us-east-1](#module\_dspm-environment-us-east-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-us-east-2"></a> [dspm-environment-us-east-2](#module\_dspm-environment-us-east-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-us-west-1"></a> [dspm-environment-us-west-1](#module\_dspm-environment-us-west-1) | ../dspm-environments/ | n/a |
| <a name="module_dspm-environment-us-west-2"></a> [dspm-environment-us-west-2](#module\_dspm-environment-us-west-2) | ../dspm-environments/ | n/a |
| <a name="module_dspm_roles"></a> [dspm\_roles](#module\_dspm\_roles) | ../dspm-roles/ | n/a |
| <a name="module_realtime_visibility_main"></a> [realtime\_visibility\_main](#module\_realtime\_visibility\_main) | ../realtime-visibility/ | n/a |
| <a name="module_rules_af-south-1"></a> [rules\_af-south-1](#module\_rules\_af-south-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-east-1"></a> [rules\_ap-east-1](#module\_rules\_ap-east-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-northeast-1"></a> [rules\_ap-northeast-1](#module\_rules\_ap-northeast-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-northeast-2"></a> [rules\_ap-northeast-2](#module\_rules\_ap-northeast-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-northeast-3"></a> [rules\_ap-northeast-3](#module\_rules\_ap-northeast-3) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-south-1"></a> [rules\_ap-south-1](#module\_rules\_ap-south-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-south-2"></a> [rules\_ap-south-2](#module\_rules\_ap-south-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-southeast-1"></a> [rules\_ap-southeast-1](#module\_rules\_ap-southeast-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-southeast-2"></a> [rules\_ap-southeast-2](#module\_rules\_ap-southeast-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-southeast-3"></a> [rules\_ap-southeast-3](#module\_rules\_ap-southeast-3) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ap-southeast-4"></a> [rules\_ap-southeast-4](#module\_rules\_ap-southeast-4) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_ca-central-1"></a> [rules\_ca-central-1](#module\_rules\_ca-central-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-central-1"></a> [rules\_eu-central-1](#module\_rules\_eu-central-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-central-2"></a> [rules\_eu-central-2](#module\_rules\_eu-central-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-north-1"></a> [rules\_eu-north-1](#module\_rules\_eu-north-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-south-1"></a> [rules\_eu-south-1](#module\_rules\_eu-south-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-south-2"></a> [rules\_eu-south-2](#module\_rules\_eu-south-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-west-1"></a> [rules\_eu-west-1](#module\_rules\_eu-west-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-west-2"></a> [rules\_eu-west-2](#module\_rules\_eu-west-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_eu-west-3"></a> [rules\_eu-west-3](#module\_rules\_eu-west-3) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_me-central-1"></a> [rules\_me-central-1](#module\_rules\_me-central-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_me-south-1"></a> [rules\_me-south-1](#module\_rules\_me-south-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_sa-east-1"></a> [rules\_sa-east-1](#module\_rules\_sa-east-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-east-1"></a> [rules\_us-east-1](#module\_rules\_us-east-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-east-2"></a> [rules\_us-east-2](#module\_rules\_us-east-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-gov-east-1"></a> [rules\_us-gov-east-1](#module\_rules\_us-gov-east-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-gov-west-1"></a> [rules\_us-gov-west-1](#module\_rules\_us-gov-west-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-west-1"></a> [rules\_us-west-1](#module\_rules\_us-west-1) | ../realtime-visibility-rules/ | n/a |
| <a name="module_rules_us-west-2"></a> [rules\_us-west-2](#module\_rules\_us-west-2) | ../realtime-visibility-rules/ | n/a |
| <a name="module_sensor_management"></a> [sensor\_management](#module\_sensor\_management) | ../sensor-management/ | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_regions.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |
| [crowdstrike_cloud_aws_account.target](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/data-sources/cloud_aws_account) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Account type can be either 'commercial' or 'gov' | `string` | `"commercial"` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to be used for this registration | `string` | n/a | yes |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | n/a | `string` | `""` | no |
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
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The ARN of the reader role | `string` | `""` | no |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | The intermediate role that is allowed to assume the reader role | `string` | `""` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if this is a gov account | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank when onboarding single account | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The AWS region where resources should be deployed | `string` | n/a | yes |
| <a name="input_realtime_visibility_regions"></a> [realtime\_visibility\_regions](#input\_realtime\_visibility\_regions) | The list of regions to onboard Realtime Visibility monitoring | `list(string)` | `[]` | no |
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

locals {
  falcon_client_id           = "<your-falcon-client-id>"
  falcon_client_secret       = "<your-falcon-client-secret>"
  account_id                 = "<your aws account id>"
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
  client_id     = local.falcon_client_id
  client_secret = local.falcon_client_secret
}

# Provision AWS account in Falcon.
resource "crowdstrike_cloud_aws_account" "this" {
  account_id                         = local.account_id
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
  source                      = "CrowdStrike/fcs/aws//modules/registration-profile"
  aws_profile                 = "<aws profile for your management account>"
  falcon_client_id            = local.falcon_client_id
  falcon_client_secret        = local.falcon_client_secret
  account_id                  = local.account_id
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = local.use_existing_cloudtrail
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_arn           = crowdstrike_cloud_aws_account.this.iam_role_arn
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
# - replace `aws_profile` with the correct profile for your child account
module "fcs_child_account_1" {
  source                      = "CrowdStrike/fcs/aws//modules/registration-profile"
  aws_profile                 = "<aws profile for this child account>"
  falcon_client_id            = local.falcon_client_id
  falcon_client_secret        = local.falcon_client_secret
  organization_id             = local.organization_id
  primary_region              = local.primary_region
  enable_sensor_management    = local.enable_sensor_management
  enable_realtime_visibility  = local.enable_realtime_visibility
  enable_idp                  = local.enable_idp
  realtime_visibility_regions = ["all"]
  use_existing_cloudtrail     = true # use the cloudtrail at the org level
  enable_dspm                 = local.enable_dspm
  dspm_regions                = local.dspm_regions

  iam_role_arn           = crowdstrike_cloud_aws_account.this.iam_role_arn
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