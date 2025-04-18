<!-- BEGIN_TF_DOCS -->
![CrowdStrike DSPM resources terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the global AWS IAM roles and permissions required for CrowdStrike's Data Security and Posture Management (DSPM) feature. This module handles the account-wide authentication components, while region-specific resources should be deployed using the companion [dspm-environments](../dspm-environments/) module in each region where DSPM monitoring is desired.

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
      version = ">= 0.0.19"
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

module "dspm_roles" {
  source                = "CrowdStrike/cloud-registration/aws//modules/dspm-roles/"
  dspm_role_name        = data.crowdstrike_cloud_aws_account.target.accounts[0].dspm_role_name
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  external_id           = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  dspm_regions          = ["us-east-1"]
}

module "dspm_environments" {
  source         = "CrowdStrike/cloud-registration/aws//modules/dspm-environments/"
  dspm_role_name = data.crowdstrike_cloud_aws_account.target.accounts[0].dspm_role_name
  region         = "us-east-1"
  depends_on     = [module.dspm_roles]
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.crowdstrike_aws_dspm_integration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.crowdstrike_aws_dspm_scanner_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.crowdstrike_bucket_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_cloud_scan_supplemental](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_dynamodb_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_logs_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_rds_clone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_redshift_clone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_redshift_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_run_data_scanner_restricted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.crowdstrike_secret_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cloud_watch_logs_read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.client_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.client_secrets_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_cloud_scan_supplemental_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_rds_clone_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_redshift_clone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.crowdstrike_run_data_scanner_restricted_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dspm_regions"></a> [dspm\_regions](#input\_dspm\_regions) | The regions in which DSPM scanning environments will be created | `list(string)` | <pre>[<br/>  "us-east-1"<br/>]</pre> | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that CrowdStrike will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_dspm_scanner_role_name"></a> [dspm\_scanner\_role\_name](#input\_dspm\_scanner\_role\_name) | The unique name of the IAM role that CrowdStrike Scanner will be assuming | `string` | `"CrowdStrikeDSPMScannerRole"` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | Unique ID for customer | `string` | n/a | yes |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | CrowdStrike client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | CrowdStrike client secret | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | ARN of the CrowdStrike assuming role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dspm_role_arn"></a> [dspm\_role\_arn](#output\_dspm\_role\_arn) | The arn of the IAM role that CrowdStrike will be assuming |
| <a name="output_dspm_scanner_role_arn"></a> [dspm\_scanner\_role\_arn](#output\_dspm\_scanner\_role\_arn) | The arn of the IAM role that CrowdStrike Scanner will be assuming |
| <a name="output_integration_role_unique_id"></a> [integration\_role\_unique\_id](#output\_integration\_role\_unique\_id) | The unique ID of the DSPM integration role |
| <a name="output_scanner_role_unique_id"></a> [scanner\_role\_unique\_id](#output\_scanner\_role\_unique\_id) | The unique ID of the DSPM scanner role |
<!-- END_TF_DOCS -->
