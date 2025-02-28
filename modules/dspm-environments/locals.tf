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

  availability_zones = [
    "${var.primary_region}a",
    "${var.primary_region}b"
  ]
}
