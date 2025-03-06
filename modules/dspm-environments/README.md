<!-- BEGIN_TF_DOCS -->
![CrowdStrike DSPM environment terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the regional AWS resources required for CrowdStrike's Data Security and Posture Management (DSPM) feature. The module must be deployed in each AWS region where DSPM monitoring is desired.

>**Note**: The [dspm-roles](../dspm-roles/) module must be deployed first to establish the necessary global IAM roles and permissions before deploying this module.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.DBSubnetGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.ElasticIPAddress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_role_policy.vpc_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.InternetGateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.crowdstrike_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.crowdstrike_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_nat_gateway.NATGateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_redshift_subnet_group.RedshiftSubnetGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_route_table.PrivateRouteTable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.PublicRouteTable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.PrivateSubnetRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.PublicSubnetRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.DBSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.EC2SecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.DBSubnetA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.DBSubnetB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.PrivateSubnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.PublicSubnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policy_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The deployment name will be used in environment installation | `string` | `"dspm-environment"` | no |
| <a name="input_dspm_role_name"></a> [dspm\_role\_name](#input\_dspm\_role\_name) | The unique name of the IAM role that CrowdStrike will be assuming | `string` | `"CrowdStrikeDSPMIntegrationRole"` | no |
| <a name="input_integration_role_unique_id"></a> [integration\_role\_unique\_id](#input\_integration\_role\_unique\_id) | The unique ID of the DSPM integration role | `string` | n/a | yes |
| <a name="input_scanner_role_unique_id"></a> [scanner\_role\_unique\_id](#input\_scanner\_role\_unique\_id) | The unique ID of the DSPM scanner role | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crowdstrike_kms_key"></a> [crowdstrike\_kms\_key](#output\_crowdstrike\_kms\_key) | The arn of the KMS key that DSPM will use |

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
      source  = "crowdstrike/crowdstrike"
      version = ">= 0.0.16"
    }
  }
}

provider "aws" {
}

provider "crowdstrike" {
  client_id     = var.falcon_client_id
  client_secret = var.falcon_client_secret
}

data "crowdstrike_cloud_aws_account" "target" {
  account_id = var.account_id
}

module "dspm_roles" {
  count                 = (var.is_primary_region && var.enable_dspm) ? 1 : 0
  source                = "CrowdStrike/fcs/aws//modules/dspm-roles/"
  dspm_role_name        = split("/", data.crowdstrike_cloud_aws_account.target.accounts.0.dspm_role_arn)[1]
  intermediate_role_arn = data.crowdstrike_cloud_aws_account.target.accounts.0.intermediate_role_arn
  external_id           = data.crowdstrike_cloud_aws_account.target.accounts.0.external_id
  falcon_client_id      = var.falcon_client_id
  falcon_client_secret  = var.falcon_client_secret
  dspm_regions          = ["us-east-1"]
}

module "dspm_environments" {
  count          = var.enable_dspm ? 1 : 0
  source         = "CrowdStrike/fcs/aws//modules/dspm-environments/"
  dspm_role_name = split("/", data.crowdstrike_cloud_aws_account.target.accounts.0.dspm_role_arn)[1]
  region         = "us-east-1"
  providers = {
    aws = aws
  }
  depends_on = [module.dspm_roles]
}

```
<!-- END_TF_DOCS -->