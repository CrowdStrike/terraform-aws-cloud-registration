# FCS AWS Organization Registration Example (Cross-Account Role)

This example demonstrates how to register an AWS Organization with CrowdStrike Falcon Cloud Security (FCS) using cross-account IAM roles. It shows how to configure both the management account and child accounts within the organization.

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail at organization level)
- Identity Protection (IDP)
- Sensor Management
- Data Security Posture Management (DSPM)

## Architecture Overview

This example:
- Configures the AWS Organization management account
- Provides a template for child account registration
- Uses organization-level CloudTrail for Real-time Visibility
- Deploys using cross-account IAM roles

## Prerequisites

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
3. CrowdStrike API credentials (see [Pre-requisites](../../README.md#pre-requisites) for details)
4. AWS Organization setup with management and child accounts
5. Appropriate permissions to create resources in all accounts

## Deploy

1. Set required environment variables:
```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
export TF_VAR_organization_id=<your aws organization id>
export TF_VAR_aws_role_name=<your aws cross account role name>
```

2. Initialize and apply Terraform:
```sh
terraform init
terraform apply
```

Enter `yes` at command prompt to apply

## Adding Child Accounts
To onboard additional child accounts:

1. Duplicate the fcs_child_account_1 module block in main.tf
2. Update the module name and variables as needed
3. Apply the changes


## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```
