# fcs-aws-native-terraform
<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_crowdstrike"></a> [crowdstrike](#provider\_crowdstrike) | n/a |
## Resources

| Name | Type |
|------|------|
| [crowdstrike_cloud_aws_account.this](https://registry.terraform.io/providers/crowdstrike/crowdstrike/latest/docs/resources/cloud_aws_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile to be used when creating resources | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to be used when creating resources | `string` | n/a | yes |
| <a name="input_credentials_storage_mode"></a> [credentials\_storage\_mode](#input\_credentials\_storage\_mode) | Storage mode for Falcon API credentials: 'lambda' (Lambda environment variables) or 'secret' (AWS Secret) | `string` | `"secret"` | no |
| <a name="input_custom_role_name"></a> [custom\_role\_name](#input\_custom\_role\_name) | Custom role name for Asset Inventory integration | `string` | `""` | no |
| <a name="input_dspm_custom_role"></a> [dspm\_custom\_role](#input\_dspm\_custom\_role) | The custom IAM role name for Data Security Posture Managment integration | `string` | `""` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Set to true to enable Data Security Posture Managment | `bool` | `false` | no |
| <a name="input_enable_realtime_visibility"></a> [enable\_realtime\_visibility](#input\_enable\_realtime\_visibility) | Set to true to enable behavior assessment | `bool` | `false` | no |
| <a name="input_enable_sensor_management"></a> [enable\_sensor\_management](#input\_enable\_sensor\_management) | TBD | `bool` | n/a | yes |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_is_commercial"></a> [is\_commercial](#input\_is\_commercial) | Set to true if this is a commercial account in govcloud | `bool` | `false` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if this is a gov account | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The AWS Organization ID. Leave blank if when onboarding single account | `string` | `""` | no |
| <a name="input_organizational_unit_ids"></a> [organizational\_unit\_ids](#input\_organizational\_unit\_ids) | The Organizational Unit IDs. Leave blank when deploying to root OU | `list(string)` | `[]` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | tbd | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crowdstrike_reader_role"></a> [crowdstrike\_reader\_role](#output\_crowdstrike\_reader\_role) | n/a |

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