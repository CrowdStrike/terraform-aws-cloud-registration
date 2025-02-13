<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | n/a |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asset_inventory"></a> [asset\_inventory](#module\_asset\_inventory) | ../asset-inventory/ | n/a |
| <a name="module_realtime_visibility_main"></a> [realtime\_visibility\_main](#module\_realtime\_visibility\_main) | ../realtime-visibility/main/ | n/a |
| <a name="module_rules_af-south-1"></a> [rules\_af-south-1](#module\_rules\_af-south-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-east-1"></a> [rules\_ap-east-1](#module\_rules\_ap-east-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-northeast-1"></a> [rules\_ap-northeast-1](#module\_rules\_ap-northeast-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-northeast-2"></a> [rules\_ap-northeast-2](#module\_rules\_ap-northeast-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-northeast-3"></a> [rules\_ap-northeast-3](#module\_rules\_ap-northeast-3) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-south-1"></a> [rules\_ap-south-1](#module\_rules\_ap-south-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-south-2"></a> [rules\_ap-south-2](#module\_rules\_ap-south-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-southeast-1"></a> [rules\_ap-southeast-1](#module\_rules\_ap-southeast-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-southeast-2"></a> [rules\_ap-southeast-2](#module\_rules\_ap-southeast-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-southeast-3"></a> [rules\_ap-southeast-3](#module\_rules\_ap-southeast-3) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ap-southeast-4"></a> [rules\_ap-southeast-4](#module\_rules\_ap-southeast-4) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_ca-central-1"></a> [rules\_ca-central-1](#module\_rules\_ca-central-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-central-1"></a> [rules\_eu-central-1](#module\_rules\_eu-central-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-central-2"></a> [rules\_eu-central-2](#module\_rules\_eu-central-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-north-1"></a> [rules\_eu-north-1](#module\_rules\_eu-north-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-south-1"></a> [rules\_eu-south-1](#module\_rules\_eu-south-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-south-2"></a> [rules\_eu-south-2](#module\_rules\_eu-south-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-west-1"></a> [rules\_eu-west-1](#module\_rules\_eu-west-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-west-2"></a> [rules\_eu-west-2](#module\_rules\_eu-west-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_eu-west-3"></a> [rules\_eu-west-3](#module\_rules\_eu-west-3) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_me-central-1"></a> [rules\_me-central-1](#module\_rules\_me-central-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_me-south-1"></a> [rules\_me-south-1](#module\_rules\_me-south-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_sa-east-1"></a> [rules\_sa-east-1](#module\_rules\_sa-east-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_us-east-1"></a> [rules\_us-east-1](#module\_rules\_us-east-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_us-east-2"></a> [rules\_us-east-2](#module\_rules\_us-east-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_us-west-1"></a> [rules\_us-west-1](#module\_rules\_us-west-1) | ../realtime-visibility/rules/ | n/a |
| <a name="module_rules_us-west-2"></a> [rules\_us-west-2](#module\_rules\_us-west-2) | ../realtime-visibility/rules/ | n/a |
| <a name="module_sensor_management"></a> [sensor\_management](#module\_sensor\_management) | ../sensor-management/ | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_regions.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |
| [crowdstrike_cloud_aws_accounts.target](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/data-sources/cloud_aws_accounts) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to be used for this registration | `string` | n/a | yes |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_enable_idp"></a> [enable\_idp](#input\_enable\_idp) | Set to true to install Identity Protection resources | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to install realtime visibility resources | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | Set to true to install 1Click Sensor Management resources | `bool` | n/a | yes |
| <a name="input_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#input\_eventbridge\_role\_arn) | Eventbridge role ARN | `string` | `""` | no |
| <a name="input_eventbus_arn"></a> [eventbus\_arn](#input\_eventbus\_arn) | Eventbus ARN to send events to | `string` | `""` | no |
| <a name="input_excluded_regions"></a> [excluded\_regions](#input\_excluded\_regions) | The regions to be excluded for Realtime Visibility monitoring | `list(string)` | `[]` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | The external ID used to assume the AWS reader role | `string` | `""` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The ARN of the reader role | `string` | `""` | no |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | The intermediate role that is allowed to assume the reader role | `string` | `""` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if this is a gov account | `bool` | n/a | yes |
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
}

module "crowdstrike_fcs" {
  # source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/terraform-cspm-aws/0.1.2/terraform-cspm-aws.tar.gz"
  source = "./fcs"

  aws_profile                 = var.aws_profile
  aws_region                  = var.aws_region
  client_id                   = var.client_id
  client_secret               = var.client_secret
  permissions_boundary        = var.permissions_boundary
  behavior_assessment_enabled = var.behavior_assessment_enabled
  sensor_management_enabled   = var.sensor_management_enabled

  # TODO: remove this
  api_url = var.api_url
}

output "crowdstrike_reader_role" {
  value = module.crowdstrike_fcs.crowdstrike_reader_role
}
```
<!-- END_TF_DOCS -->