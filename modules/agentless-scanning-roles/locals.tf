locals {
  crowdstrike_tag_key        = "ProvisionedBy"
  crowdstrike_tag_value      = "CrowdStrike"
  logical_tag_key            = "CrowdStrikeLogicalId"
  deployment_regions_tag_key = "CrowdStrikeDeploymentRegions"

  # Extract VPC ARNs from custom VPC resources map for IAM policy conditions
  custom_vpc_arns = [
    for region, resources in var.agentless_scanning_custom_vpc_resources_map :
    "arn:aws:ec2:${region}:${data.aws_caller_identity.current.account_id}:vpc/${resources.vpc}"
  ]

  # Condition to determine if this is the host account
  is_host_account = var.agentless_scanning_host_account_id == var.account_id || var.agentless_scanning_host_account_id == ""

  # DSPM policy conditions
  create_s3_policy       = var.enable_dspm && var.dspm_s3_access
  create_rds_policy      = var.enable_dspm && var.dspm_rds_access
  create_dynamodb_policy = var.enable_dspm && var.dspm_dynamodb_access
  create_redshift_policy = var.enable_dspm && var.dspm_redshift_access
  create_ebs_policy      = (var.enable_dspm && var.dspm_ebs_access) || var.enable_vulnerability_scanning
}
