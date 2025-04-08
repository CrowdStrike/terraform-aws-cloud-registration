# FCS Single Account Registration (Multi-Region with Custom Providers)

This example demonstrates how to register a single AWS account with CrowdStrike Falcon Cloud Security (FCS) using custom AWS provider configurations. It showcases a multi-region deployment where you have full control over the AWS provider configuration for each region.

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail)
- Identity Protection (IDP)
- Sensor Management
- Data Security Posture Management (DSPM)

## Architecture Overview

This example:
- Deploys FCS components across multiple AWS regions (us-east-1, us-east-2, us-west-1, us-west-2)
- Uses explicit provider configurations for each region
- Requires you to configure AWS authentication using your preferred method (environment variables, shared credentials, assume role, etc.)

## Prerequisites

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
3. CrowdStrike API credentials (see [Pre-requisites](../../README.md#pre-requisites) for details)
4. AWS authentication configured for all target regions

## Deploy

1. Configure your AWS providers as needed in your Terraform configuration

2. Set required environment variables:
```sh
export TF_VAR_falcon_client_id=<your client id>
export TF_VAR_falcon_client_secret=<your client secret>
export TF_VAR_account_id=<your aws account id>
```

3. Initialize and apply Terraform:
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

>**Note**: This example requires you to explicitly define AWS providers for each region where you want to deploy FCS components. See the main.tf file for the provider configuration pattern that needs to be replicated for each desired region.
