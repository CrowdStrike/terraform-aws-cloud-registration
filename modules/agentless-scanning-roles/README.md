<!-- BEGIN_TF_DOCS -->
![CrowdStrike DSPM resources terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the global AWS IAM roles and permissions required for CrowdStrike's Agentless scanning features, which include Data Security and Posture Management (DSPM) and Vulnerability scanning. This module handles the account-wide authentication components, while region-specific resources should be deployed using the companion [agentless-scanning-environments](../agentless-scanning-environments/) module in each region where DSPM/Vulnerability scanning is desired.

## Usage

```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    crowdstrike = {
      source  = "CrowdStrike/crowdstrike"
      version = ">= 0.0.44"
    }
  }
}

provider "aws" {}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "agentless_scanning_roles" {
  source                       = "CrowdStrike/cloud-registration/aws//modules/agentless-scanning-roles/"
  agentless_scanning_role_name = data.crowdstrike_cloud_aws_account.target.accounts[0].agentless_scanning_role_name
  intermediate_role_arn        = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  external_id                  = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  falcon_client_id             = var.falcon_client_id
  falcon_client_secret         = var.falcon_client_secret
  agentless_scanning_regions   = ["us-east-1"]
}

module "agentless_scanning_environments" {
  source                     = "CrowdStrike/cloud-registration/aws//modules/agentless-scanning-environments/"
  integration_role_unique_id = module.agentless_scanning_roles[0].integration_role_unique_id
  scanner_role_unique_id     = module.agentless_scanning_roles[0].scanner_role_unique_id
  depends_on                 = [module.agentless_scanning_roles]
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.crowdstrike_aws_agentless_scanning_integration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.crowdstrike_assume_target_scanner_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_bucket_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_cloud_scan_supplemental](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_dynamodb_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_ebs_volume_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_logs_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_rds_clone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_rds_clone_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_rds_clone_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_redshift_clone_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_redshift_clone_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_redshift_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_run_data_scanner_restricted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_secret_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_ssm_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_vulnerability_scanning_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_vulnerability_scanning_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_vulnerability_scanning_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.run_data_scanner_custom_vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cloud_watch_logs_read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.client_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.client_secrets_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_parameter.agentless_scanning_root_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_cloud_scan_supplemental_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_rds_clone_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_rds_clone_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_rds_clone_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_redshift_clone_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_redshift_clone_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_run_data_scanner_restricted_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_ssm_reader_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_vulnerability_scanning_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_vulnerability_scanning_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_vulnerability_scanning_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.run_data_scanner_custom_vpcs_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_agentless_scanning_custom_vpc_resources_map"></a> [agentless\_scanning\_custom\_vpc\_resources\_map](#input\_agentless\_scanning\_custom\_vpc\_resources\_map) | Map of region-specific VPC resources for existing VPC deployment. Keys are region names, values are objects containing VPC resource IDs. | <pre>map(object({<br/>    vpc            = string<br/>    scanner_subnet = string<br/>    scanner_sg     = string<br/>    db_subnet_a    = string<br/>    db_subnet_b    = string<br/>    db_sg          = string<br/>  }))</pre> | `{}` | no |
| <a name="input_agentless_scanning_host_account_id"></a> [agentless\_scanning\_host\_account\_id](#input\_agentless\_scanning\_host\_account\_id) | The AWS account ID where agentless scanning host resources are deployed | `string` | `""` | no |
| <a name="input_agentless_scanning_host_scanner_role_name"></a> [agentless\_scanning\_host\_scanner\_role\_name](#input\_agentless\_scanning\_host\_scanner\_role\_name) | Name of agentless scanning scanner role in host account | `string` | `"CrowdStrikeAgentlessScanningScannerRole"` | no |
| <a name="input_agentless_scanning_regions"></a> [agentless\_scanning\_regions](#input\_agentless\_scanning\_regions) | List of regions where agentless scanning will be deployed | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_agentless_scanning_role_name"></a> [agentless\_scanning\_role\_name](#input\_agentless\_scanning\_role\_name) | The unique name of the IAM role that Agentless scanning will be assuming | `string` | `"CrowdStrikeAgentlessScanningIntegrationRole"` | no |
| <a name="input_agentless_scanning_scanner_role_name"></a> [agentless\_scanning\_scanner\_role\_name](#input\_agentless\_scanning\_scanner\_role\_name) | The unique name of the IAM role that Agentless scanning scanner will be assuming | `string` | `"CrowdStrikeAgentlessScanningScannerRole"` | no |
| <a name="input_agentless_scanning_use_custom_vpc"></a> [agentless\_scanning\_use\_custom\_vpc](#input\_agentless\_scanning\_use\_custom\_vpc) | Whether to use existing custom VPC resources for ALL deployment regions (requires agentless\_scanning\_custom\_vpc\_resources\_map with all regions) | `bool` | `false` | no |
| <a name="input_dspm_dynamodb_access"></a> [dspm\_dynamodb\_access](#input\_dspm\_dynamodb\_access) | Apply permissions for DynamoDB table scanning | `bool` | `true` | no |
| <a name="input_dspm_rds_access"></a> [dspm\_rds\_access](#input\_dspm\_rds\_access) | Apply permissions for RDS instance scanning | `bool` | `true` | no |
| <a name="input_dspm_redshift_access"></a> [dspm\_redshift\_access](#input\_dspm\_redshift\_access) | Apply permissions for Redshift cluster scanning | `bool` | `true` | no |
| <a name="input_dspm_s3_access"></a> [dspm\_s3\_access](#input\_dspm\_s3\_access) | Apply permissions for S3 bucket scanning | `bool` | `true` | no |
| <a name="input_enable_dspm"></a> [enable\_dspm](#input\_enable\_dspm) | Enable DSPM scanning resources and permissions | `bool` | `false` | no |
| <a name="input_enable_vulnerability_scanning"></a> [enable\_vulnerability\_scanning](#input\_enable\_vulnerability\_scanning) | Enable vulnerability scanning resources and permissions | `bool` | `false` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | Unique ID for customer | `string` | n/a | yes |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | CrowdStrike client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | CrowdStrike client secret | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | ARN of the CrowdStrike assuming role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_integration_role_name"></a> [integration\_role\_name](#output\_integration\_role\_name) | The arn of the IAM role that CrowdStrike will be assuming |
| <a name="output_integration_role_unique_id"></a> [integration\_role\_unique\_id](#output\_integration\_role\_unique\_id) | The unique ID of the DSPM integration role |
| <a name="output_scanner_role_name"></a> [scanner\_role\_name](#output\_scanner\_role\_name) | The arn of the IAM role that CrowdStrike Scanner will be assuming |
| <a name="output_scanner_role_unique_id"></a> [scanner\_role\_unique\_id](#output\_scanner\_role\_unique\_id) | The unique ID of the DSPM scanner role |
<!-- END_TF_DOCS -->
