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
}
