<!-- BEGIN_TF_DOCS -->
![CrowdStrike Real-time Visibility and Detection terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys AWS resources required for CrowdStrike's Real-time Visibility and Detection feature, which identifies indicators of attack (IOAs) and monitors cloud asset behavior in real-time. Note: This module must be deployed separately in each AWS region you wish to monitor, as it manages region-specific resources.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
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
| [aws_iam_policy.s3_log_consumption_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.s3_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.s3_log_consumption_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
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
| [aws_sns_topic_subscription.cloudtrail_logs_sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.cloudtrail_logs_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.cloudtrail_logs_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.cloudtrail_logs_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_arn.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | Name of the S3 bucket for CloudTrail logs | `string` | n/a | yes |
| <a name="input_create_rules"></a> [create\_rules](#input\_create\_rules) | Set to false if you don't want to enable monitoring in this region | `bool` | `true` | no |
| <a name="input_eventbridge_role_name"></a> [eventbridge\_role\_name](#input\_eventbridge\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_eventbus_arn"></a> [eventbus\_arn](#input\_eventbus\_arn) | EventBus ARN(s) to send events to - single ARN for commercial, comma-separated for gov multi-region | `string` | n/a | yes |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID for secure cross-account role assumption | `string` | `""` | no |
| <a name="input_falcon_client_id"></a> [falcon\_client\_id](#input\_falcon\_client\_id) | Falcon API Client ID | `string` | n/a | yes |
| <a name="input_falcon_client_secret"></a> [falcon\_client\_secret](#input\_falcon\_client\_secret) | Falcon API Client Secret | `string` | n/a | yes |
| <a name="input_intermediate_role_arn"></a> [intermediate\_role\_arn](#input\_intermediate\_role\_arn) | CrowdStrike Role ARN for cross-account access | `string` | `""` | no |
| <a name="input_is_gov"></a> [is\_gov](#input\_is\_gov) | Set to true if you are deploying in gov Falcon | `bool` | `false` | no |
| <a name="input_is_gov_commercial"></a> [is\_gov\_commercial](#input\_is\_gov\_commercial) | Set to true if this is a commercial account in gov-cloud | `bool` | `false` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Whether the Cloudtrail to be created is an organization trail | `bool` | `false` | no |
| <a name="input_is_primary_region"></a> [is\_primary\_region](#input\_is\_primary\_region) | Whether this is the primary region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. | `bool` | `false` | no |
| <a name="input_log_ingestion_kms_key_arn"></a> [log\_ingestion\_kms\_key\_arn](#input\_log\_ingestion\_kms\_key\_arn) | Optional KMS key ARN for decrypting S3 objects (when log\_ingestion\_method=s3) | `string` | `""` | no |
| <a name="input_log_ingestion_method"></a> [log\_ingestion\_method](#input\_log\_ingestion\_method) | Choose the method for ingesting CloudTrail logs - EventBridge (default) or S3 | `string` | `"eventbridge"` | no |
| <a name="input_log_ingestion_s3_bucket_name"></a> [log\_ingestion\_s3\_bucket\_name](#input\_log\_ingestion\_s3\_bucket\_name) | S3 bucket name containing CloudTrail logs (required when log\_ingestion\_method=s3) | `string` | `""` | no |
| <a name="input_log_ingestion_s3_bucket_prefix"></a> [log\_ingestion\_s3\_bucket\_prefix](#input\_log\_ingestion\_s3\_bucket\_prefix) | Optional S3 bucket prefix/path for CloudTrail logs (when log\_ingestion\_method=s3) | `string` | `""` | no |
| <a name="input_log_ingestion_sns_topic_arn"></a> [log\_ingestion\_sns\_topic\_arn](#input\_log\_ingestion\_sns\_topic\_arn) | SNS topic ARN that publishes S3 object creation events (required when log\_ingestion\_method=s3) | `string` | `""` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region for deploying global AWS resources (IAM roles, policies, etc.) that are account-wide and only need to be created once. Distinct from agentless\_scanning\_regions which controls region-specific resource deployment. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to be added to all resource names | `string` | `""` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | The suffix to be added to all resource names | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Whether to use an existing CloudTrail or create a new one | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_lambda_alias"></a> [eventbridge\_lambda\_alias](#output\_eventbridge\_lambda\_alias) | The AWS lambda alias to forward events to |
| <a name="output_s3_log_role_arn"></a> [s3\_log\_role\_arn](#output\_s3\_log\_role\_arn) | ARN of the IAM role for S3 log ingestion |
| <a name="output_sns_subscription_arn"></a> [sns\_subscription\_arn](#output\_sns\_subscription\_arn) | ARN of the SNS subscription linking customer topic to SQS queue |
| <a name="output_sqs_dlq_arn"></a> [sqs\_dlq\_arn](#output\_sqs\_dlq\_arn) | ARN of the dead letter queue for failed messages |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | ARN of the SQS queue for CloudTrail log notifications |
<!-- END_TF_DOCS -->
