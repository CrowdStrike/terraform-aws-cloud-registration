<!-- BEGIN_TF_DOCS -->
![CrowdStrike Asset Inventory terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the required AWS resources to enable CrowdStrike's Asset Inventory feature in AWS environments. The solution helps organizations track both managed and unmanaged AWS assets, enabling better cloud security posture management.

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


module "asset_inventory" {
  source = "CrowdStrike/cloud-registration/aws//modules/asset-inventory"

  external_id           = data.crowdstrike_cloud_aws_account.target.accounts[0].external_id
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts[0].intermediate_role_arn
  role_name             = data.crowdstrike_cloud_aws_account.target.accounts[0].iam_role_name
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
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | Unique identifier provided by CrowdStrike for secure cross-account access | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | ARN of CrowdStrike's intermediate role | `string` | n/a | yes |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the asset inventory reader IAM role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_reader_role_arn"></a> [reader\_role\_arn](#output\_reader\_role\_arn) | The reader role ARN used for asset inventory |
<!-- END_TF_DOCS -->
