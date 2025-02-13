# fcs-aws-native-terraform
<!-- BEGIN_TF_DOCS -->
![CrowdStrike FalconPy](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)<br/>

## Providers

No providers.
## Modules

No modules.
## Resources

No resources.
## Inputs

No inputs.
## Outputs

No outputs.

## Usage

```hcl
terraform {
  required_version = ">= 0.15"
}

module "crowdstrike_fcs" {
  # source = "https://cs-dev-cloudconnect-templates.s3.amazonaws.com/terraform/modules/terraform-cspm-aws/0.1.2/terraform-cspm-aws.tar.gz"
  source = "./fcs"

  aws_profile                 = var.aws_profile
  aws_region                  = var.aws_region
  client_id                   = var.client_id
  client_secret               = var.client_secret
  permissions_boundary        = var.permissions_boundary
  behavior_assessment_enabled = var.behavior_assessment_enabled
  sensor_management_enabled   = var.sensor_management_enabled

  # TODO: remove this
  api_url = var.api_url
}

output "crowdstrike_reader_role" {
  value = module.crowdstrike_fcs.crowdstrike_reader_role
}
```
<!-- END_TF_DOCS -->