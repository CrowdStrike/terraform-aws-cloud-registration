# FCS AWS Organization Registration Example (Cross-Account Role)

This example demonstrates how to register an AWS Organization with CrowdStrike Falcon Cloud Security (FCS) using cross-account IAM roles. It shows how to configure both the management account and child accounts within the organization.

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail at organization level)
- Identity Protection (IDP)
- Sensor Management
- Agentless Scanning:
    - Data Security Posture Management (DSPM)
    - Vulnerability Scanning

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

## Agentless Scanning Configurations

### Cross Account Scanning

In this example, Agentless scanning is configured to scan assets in the entire organization from a single account that will host data scanners. 
It is important that the deployment complete in the host account before it begins in the target accounts. In order to create this dependency, the target modules utilize the output of the host module.

Alternate configuration options:
- In this example, the host account is the management account. You may choose to configure a different account in the organization as the host account. To configure a different host account:
    * Set the value of the variable `agentless_scanning_host_account_id` to your chosen host account.
    * In all target account modules, set the variables `agentless_scanning_host_role_name` to depend on the output of your host account module in order to ensure the host deployment completes first. Example:
        * ```hcl
          agentless_scanning_host_role_name  = module.<name of host account module>.agentless_scanning_integration_role_name

- You may also choose to configure per-account scanning, in which Agentless scanning host infrastructure is deployed in each of the organization's accounts. To configure per-account scanning:
    * Do not pass any value for the variable `agentless_scanning_host_account_id`. In the provided example, remove the following code from the child account modules:
        * ```hcl
      agentless_scanning_host_account_id   = var.account_id
    * When deploying per-account scanning, there is no need to pass a value for the variable `agentless_scanning_host_role_name` to any of the modules.

## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```
