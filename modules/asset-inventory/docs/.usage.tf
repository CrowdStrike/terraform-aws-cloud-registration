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
