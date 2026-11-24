locals {
  crowdstrike_tag_key   = "ProvisionedBy"
  crowdstrike_tag_value = "CrowdStrike"
  logical_tag_key       = "CrowdStrikeLogicalId"

  logical_subnet_group          = "DBSubnetGroup"
  logical_redshift_subnet_group = "RedshiftSubnetGroup"
  logical_private_subnet        = "PrivateSubnet"
  logical_elastic_ip            = "ElasticIP"
  logical_ec2_security_group    = "EC2SecurityGroup"
  logical_db_security_group     = "DBSecurityGroup"
  logical_kms_key               = "KMSKey"
  aws_region                    = data.aws_region.current.id
  account_id                    = data.aws_caller_identity.current.account_id
  aws_partition                 = data.aws_partition.current.partition

  # Condition to determine if this is the host account
  is_host_account = var.agentless_scanning_host_account_id == var.account_id || var.agentless_scanning_host_account_id == ""
  # Condition to determine whether scanning infrastructure should be created in this account
  create_scanning_infrastructure = local.is_host_account && !var.use_custom_vpc

  # New registrations add the prefix/suffix to the named resources and the Environment parameter, so
  # several registrations can share one account. Empty affixes keep the legacy names, as in the CFT
  resource_prefix            = var.agentless_use_resource_affixes ? var.resource_prefix : ""
  resource_suffix            = var.agentless_use_resource_affixes ? var.resource_suffix : ""
  kms_alias_name             = "alias/${local.resource_prefix}CrowdStrikeAgentlessScanningKey${local.resource_suffix}"
  environment_parameter_name = "/CrowdStrike/AgentlessScanning/${local.resource_prefix}Environment${local.resource_suffix}"
}
