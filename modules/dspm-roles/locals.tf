locals {
  crowdstrike_tag_key        = "ProvisionedBy"
  crowdstrike_tag_value      = "CrowdStrike"
  logical_tag_key            = "CrowdStrikeLogicalId"
  deployment_regions_tag_key = "CrowdStrikeDeploymentRegions"

  # Condition to determine if this is the host account
  is_host_account = var.agentless_scanning_host_account_id == var.account_id || var.agentless_scanning_host_account_id == ""
}
