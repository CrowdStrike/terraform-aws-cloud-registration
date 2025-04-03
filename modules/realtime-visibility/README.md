<!-- BEGIN_TF_DOCS -->
![CrowdStrike Real-time Visibility and Detection terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys AWS resources required for CrowdStrike's Real-time Visibility and Detection feature, which identifies indicators of attack (IOAs) and monitors cloud asset behavior in real-time. Note: This module must be deployed separately in each AWS region you wish to monitor, as it manages region-specific resources.

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

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "realtime_visibility" {
  source = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility/"

  use_existing_cloudtrail = true
  cloudtrail_bucket_name  = data.crowdstrike_cloud_aws_account.target.accounts[0].cloudtrail_bucket_name

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us_east_1" {
  source               = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility-rules"
  eventbus_arn         = data.crowdstrike_cloud_aws_account.target.accounts[0].eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main[0].eventbridge_role_arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us_east_2" {
  source               = "CrowdStrike/cloud-registration/aws//modules/realtime-visibility-rules"
  eventbus_arn         = data.crowdstrike_cloud_aws_account.target.accounts[0].eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main[0].eventbridge_role_arn

  providers = {
    aws = aws.us-east-2
  }
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.7.1 |
## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_event_rule.ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.eventbridge_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.s3_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_alias.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | Name of the S3 bucket for CloudTrail logs | `string` | n/a | yes |
| <a name="input_eventbridge_role_name"></a> [eventbridge\_role\_name](#input\_eventbridge\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_eventbus_arn"></a> [eventbus\_arn](#input\_eventbus\_arn) | Eventbus ARN to send events to | `string` | n/a | yes |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_is_gov_commercial"></a> [is\_gov\_commercial](#input\_is\_gov\_commercial) | Set to true if this is a commercial account in gov-cloud | `bool` | `false` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Whether the Cloudtrail to be created is an organization trail | `bool` | `false` | no |
| <a name="input_is_primary_region"></a> [is\_primary\_region](#input\_is\_primary\_region) | Whether this is the primary region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. | `bool` | `false` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from dspm\_regions which controls region-specific resource deployment. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to be added to all resource names | `string` | `""` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | The suffix to be added to all resource names | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Whether to use an existing CloudTrail or create a new one | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_lambda_alias"></a> [eventbridge\_lambda\_alias](#output\_eventbridge\_lambda\_alias) | The AWS lambda alias to forward events to |
<!-- END_TF_DOCS -->
