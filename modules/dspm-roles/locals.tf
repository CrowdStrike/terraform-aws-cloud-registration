locals {
  crowdstrike_tag_key        = "ProvisionedBy"
  crowdstrike_tag_value      = "CrowdStrike"
  logical_tag_key            = "CrowdStrikeLogicalId"
  deployment_regions_tag_key = "CrowdStrikeDeploymentRegions"
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.name
  aws_partition = data.aws_partition.current.partition
}

