<!-- BEGIN_TF_DOCS -->
![CrowdStrike Sensor Management terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the AWS resources required for CrowdStrike's 1-Click Sensor Management feature. It supports both automated deployment via AWS Systems Manager (SSM) and manual deployment using Ansible inventory generation. The module enables automated discovery of unmanaged hosts and streamlines the Falcon sensor deployment process across your AWS environment.

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

provider "aws" {}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "sensor_management" {
  source                = "CrowdStrike/cloud-registration/aws//modules/sensor-management/"
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  external_id           = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  permissions_boundary  = var.permissions_boundary
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.crowdstrike_sensor_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.orchestrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.invoke_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.orchestrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.orchestrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | Unique identifier provided by CrowdStrike for secure cross-account access | `string` | n/a | yes |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | ARN of CrowdStrike's intermediate role | `string` | n/a | yes |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
## Outputs

No outputs.
<!-- END_TF_DOCS -->
