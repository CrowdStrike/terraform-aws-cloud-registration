data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "crowdstrike-aws-dspm-roles" {
  source = "./crowdstrike-aws-dspm-roles"
  dspm_role_name = var.dspm_role_name
  dspm_scanner_role_name = var.dspm_scanner_role_name
  cs_role_arn = var.cs_role_arn
  client_id = var.client_id
  client_secret = var.client_secret
  external_id = var.external_id
}
