# FCS Single Account Registration Example

This example demonstrates how to register a single AWS account with CrowdStrike Falcon Cloud Security (FCS) using an AWS CLI profile. It showcases the deployment of multiple FCS features including Real-time Visibility, Identity Protection (IDP), Sensor Management, and Agentless Scanning (DSPM/Vulnerability scanning).

## Features Enabled

- Asset Inventory
- Real-time Visibility (using existing CloudTrail)
- Identity Protection (IDP)
- Sensor Management
- Agentless Scanning:
  - Data Security Posture Management (DSPM)
  - Vulnerability Scanning

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
