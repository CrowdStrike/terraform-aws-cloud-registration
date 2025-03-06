# FCS Single Account Registration Example

This example demonstrates how to register a single AWS account with CrowdStrike Falcon Cloud Security (FCS) using an AWS CLI profile. It showcases the deployment of multiple FCS features including Real-time Visibility, Identity Protection (IDP), Sensor Management, and DSPM.

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
4. AWS CLI profile with appropriate permissions

## Deploy

1. Set required environment variables:
```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
export TF_VAR_aws_profile=<your aws profile>
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

