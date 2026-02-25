# FCS Single Account Registration (Multi-Region with Custom Providers)

This example demonstrates how to register a single AWS account with CrowdStrike Falcon Cloud Security (FCS) using custom AWS provider configurations. It showcases a multi-region deployment where you have full control over the AWS provider configuration for each region.

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail)
- Identity Protection (IDP)
- Sensor Management
- Agentless Scanning:
  - Data Security Posture Management (DSPM)
  - Vulnerability Scanning

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

## Agentless Scanning Configurations

### Cross Account Scanning

The account in the example is configured to host Agentless scanning infrastructure.

Alternate configuration options:
- You may choose to scan this account from a previously onboarded Agentless scanning host account. To scan from a different account:
    * Ensure the deployment has successfully completed in the host account before deploying any target accounts.
    * Set the value of the variable `agentless_scanning_host_account_id` as your host AWS account ID.
    * Set the value of the variable `agentless_scanning_host_role_name` as the name of the Agentless scanning integration role in the host account.
    * Set the value of the variable `agentless_scanning_host_scanner_role_name` as the name of the Agentless scanning data scanner role in the host account.

### Custom VPC
For Agentless scanning deployments, you can optionally use your existing network resources instead of the default resources provisioned by CrowdStrike.

**Key Points:**
- Custom VPC settings apply to the entire Agentless scanning deployment across all regions
- Cannot be applied to specific Agentless scanning regions (all-or-nothing configuration)
- Requires existing VPC, subnets, and security groups in each Agentless scanning region

For detailed network requirements and validation steps, see the CrowdStrike Falcon documentation for Agentless scanning deployment with custom VPCs.

**Usage:**
```hcl
  # Enable custom VPC
  agentless_scanning_use_custom_vpc = true

  # Provide existing resources for each region
  agentless_scanning_custom_vpc_resources_map = {
    "us-east-1" = {
      vpc            = "vpc-11223344556677889"
      scanner_subnet = "subnet-11223344556677887"
      scanner_sg     = "sg-11223344556677888"
      db_subnet_a    = "subnet-11223344556677888"
      db_subnet_b    = "subnet-11223344556677889"
      db_sg          = "sg-11223344556677889"
    }
    "us-west-1" = {
      vpc            = "vpc-11223344556677888"
      scanner_subnet = "subnet-11223344556677884"
      scanner_sg     = "sg-11223344556677886"
      db_subnet_a    = "subnet-11223344556677885"
      db_subnet_b    = "subnet-11223344556677886"
      db_sg          = "sg-11223344556677887"
    }
  }
```

## Destroy

To teardown and remove all resources created by this example:

```sh
terraform destroy -auto-approve
```

>**Note**: This example requires you to explicitly define AWS providers for each region where you want to deploy FCS components. See the main.tf file for the provider configuration pattern that needs to be replicated for each desired region.
