<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_role.cs_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cspm_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cs_iam_role_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.cs_iam_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | Unique identifier provided by CrowdStrike for secure cross-account access | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | ARN of CrowdStrike's intermediate role | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the asset inventory reader IAM role | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_reader_role_arn"></a> [reader\_role\_arn](#output\_reader\_role\_arn) | TBD |

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