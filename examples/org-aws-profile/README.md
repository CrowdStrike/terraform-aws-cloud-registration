# FCS AWS Organization Registration Example (AWS Profiles)

This example demonstrates how to register an AWS Organization with CrowdStrike Falcon Cloud Security (FCS) using AWS CLI profiles. It shows how to configure both the management account and child accounts within the organization.

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
- Deploys using AWS CLI profiles for authentication

## Prerequisites

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and configured with profiles
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
3. CrowdStrike API credentials (see [Pre-requisites](../../README.md#pre-requisites) for details)
4. AWS Organization setup with management and child accounts
5. AWS CLI profiles configured for management and child accounts

## Deploy

1. Set required environment variables:
```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
export TF_VAR_organization_id=<your aws organization id>
export TF_VAR_aws_profile=<your aws profile>
```

2. Update AWS profiles in the Terraform configuration:

* Set management account profile in fcs_management_account module
* Set child account profile in fcs_child_account_1 module

3. Initialize and apply Terraform:
```sh
terraform init
terraform apply
```

Enter `yes` at command prompt to apply

## Adding Child Accounts
To onboard additional child accounts:

* Duplicate the fcs_child_account_1 module block in main.tf
* Update the module name and AWS profile for the new child account
* Apply the changes


## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```
