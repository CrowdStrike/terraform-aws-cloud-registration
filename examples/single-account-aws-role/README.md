# FCS Single Account Registration Example (Cross-Account Role)

This example demonstrates how to register a single AWS account with CrowdStrike Falcon Cloud Security (FCS) using an AWS IAM role for cross-account access. This method is particularly useful for organizations that prefer role-based access over AWS profiles.

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail)
- Identity Protection (IDP)
- Sensor Management
- Data Security and Posture Management (DSPM)

## Prerequisites

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and configured
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
3. CrowdStrike API credentials (see [Pre-requisites](../../README.md#pre-requisites) for details)
4. Existing IAM role with appropriate permissions for cross-account access

## Deploy

1. Set required environment variables:
```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
export TF_VAR_cross_account_role_name=<your aws cross account role name>
```

2. Initialize and apply Terraform:
```sh
terraform init
terraform apply
```

Enter `yes` at command prompt to apply


## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```
