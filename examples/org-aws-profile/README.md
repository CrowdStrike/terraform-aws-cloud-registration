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

## DSPM Configurations

### Cross Account Scannning

In this example, DSPM is configured to scan assets in the entire organization from a single account that will host data scanners. 
It is important that the deployment complete in the host account before it begins in the target accounts. In order to create this dependency, the target modules utilize the output of the host module.

Alternate configuration options:
- In this example, the host account is the management account. You may choose to configure a different account in the organization as the host account. To configure a different host account:
  * Set the value of the variable `agentless_scanning_host_account_id` to your chosen host account.
  * In all target account modules, set the variables `dspm_integration_role_unique_id` to depend on the output of your host account module in order to ensure the host deployment completes first. Example: 
    * ```hcl
      dspm_integration_role_unique_id = module.<name of host account module>.agentless_scanning_integration_role_unique_id
  
- You may also choose to configure per-account scanning, in which DSPM host infrastructure is deployed in each of the organization's accounts. To configure per-account scanning:
  * Do not pass any value for the variable `agentless_scanning_host_account_id`. In the provided example, remove the following code from the child account modules:
    * ```hcl
      agentless_scanning_host_account_id   = var.account_id
  * When deploying per-account scanning, there is no need to pass a value for the variable `agentless_scanning_integration_role_unique_id` to any of the modules.

## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```
