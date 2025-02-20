<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

# Terraform Modules Documentation

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
## Modules

No modules.
## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | Name of the S3 bucket for CloudTrail logs | `string` | n/a | yes |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Whether the Cloudtrail to be created is an organization trail | `bool` | `false` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The name of the policy used to set the permissions boundary for IAM roles | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The eventbridge role name | `string` | `"CrowdStrikeCSPMEventBridge"` | no |
| <a name="input_use_existing_cloudtrail"></a> [use\_existing\_cloudtrail](#input\_use\_existing\_cloudtrail) | Whether to use an existing CloudTrail or create a new one | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#output\_eventbridge\_role\_arn) | The ARN of the role used for eventbrige rules |

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
      source = "crowdstrike/crowdstrike"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
  alias   = "us-east-1"
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-east-2"
  alias   = "us-east-2"
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_accounts" "target" {
  account_id      = var.account_id
}

module "realtime_visibility_main" {
  source = "../realtime-visibility/main/"

  use_existing_cloudtrail = var.use_existing_cloudtrail
  is_organization_trail   = length(var.organization_id) > 0
  cloudtrail_bucket_name  = data.crowdstrike_cloud_aws_accounts.accounts.0.cloudtrail_bucket_name

  providers = {
    aws = aws
  }
}

module "rules_us-east-1" {
  source = "../realtime-visibility/rules/"

  eventbus_arn         = data.crowdstrike_cloud_aws_accounts.accounts.0.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us-east-2" {
  source = "../realtime-visibility/rules/"

  eventbus_arn         = data.crowdstrike_cloud_aws_accounts.accounts.0.eventbus_arn
  eventbridge_role_arn = module.realtime_visibility_main.0.eventbridge_role_arn

  providers = {
    aws = aws.us-east-2
  }
}

```
<!-- END_TF_DOCS -->
