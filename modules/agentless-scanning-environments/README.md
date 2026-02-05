<!-- BEGIN_TF_DOCS -->
![CrowdStrike DSPM environment terraform module](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Introduction

This Terraform module deploys the regional AWS resources required for CrowdStrike's Agentless scanning features, which include Data Security and Posture Management (DSPM) and Vulnerability scanning. The module must be deployed in each AWS region where DSPM/Vulnerability scanning is desired.

>**Note**: The [agentless-scanning-roles](../agentless-scanning-roles/) module must be deployed first to establish the necessary global IAM roles and permissions before deploying this module.

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
| [aws_db_subnet_group.db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.elastic_ip_address](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.crowdstrike_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.crowdstrike_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.db_subnet_a_nacl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_association.db_subnet_b_nacl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_association.private_subnet_nacl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_association.public_subnet_nacl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_rule.inbound_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.inbound_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_redshift_subnet_group.redshift_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.db_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ec2_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.scan_environment_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.db_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.dynamodb_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policy_kms_key_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_kms_key_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.custom_db_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.custom_db_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS 12 digit account ID | `string` | `""` | no |
| <a name="input_agentless_scanning_create_nat_gateway"></a> [agentless\_scanning\_create\_nat\_gateway](#input\_agentless\_scanning\_create\_nat\_gateway) | Set to true to create a NAT Gateway for agentless scanning environments | `bool` | `true` | no |
| <a name="input_agentless_scanning_host_account_id"></a> [agentless\_scanning\_host\_account\_id](#input\_agentless\_scanning\_host\_account\_id) | The AWS account ID where agentless scanning host resources are deployed | `string` | `""` | no |
| <a name="input_agentless_scanning_host_role_name"></a> [agentless\_scanning\_host\_role\_name](#input\_agentless\_scanning\_host\_role\_name) | Name of agentless scanning integration role in host account | `string` | `"CrowdStrikeAgentlessScanningIntegrationRole"` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The deployment name will be used in environment installation | `string` | `"dspm-environment"` | no |
| <a name="input_integration_role_unique_id"></a> [integration\_role\_unique\_id](#input\_integration\_role\_unique\_id) | The unique ID of the agentless scanning integration role | `string` | n/a | yes |
| <a name="input_region_vpc_config"></a> [region\_vpc\_config](#input\_region\_vpc\_config) | VPC configuration for the current region | <pre>object({<br/>    vpc            = string<br/>    scanner_subnet = string<br/>    scanner_sg     = string<br/>    db_subnet_a    = string<br/>    db_subnet_b    = string<br/>    db_sg          = string<br/>  })</pre> | `null` | no |
| <a name="input_scanner_role_unique_id"></a> [scanner\_role\_unique\_id](#input\_scanner\_role\_unique\_id) | The unique ID of the agentless scanning scanner role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources that support tagging | `map(string)` | `{}` | no |
| <a name="input_use_custom_vpc"></a> [use\_custom\_vpc](#input\_use\_custom\_vpc) | Whether to use existing custom VPC resources instead of creating new ones. When true, region\_vpc\_config must be provided. | `bool` | `false` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR block | `string` | `"10.0.0.0/16"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crowdstrike_kms_key"></a> [crowdstrike\_kms\_key](#output\_crowdstrike\_kms\_key) | The arn of the KMS key that agentless scanning will use |
<!-- END_TF_DOCS -->
