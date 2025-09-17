data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.intermediate_role_arn]
    }

    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

resource "aws_iam_role" "crowdstrike_aws_dspm_integration_role" {
  name                 = var.dspm_role_name
  path                 = "/"
  max_session_duration = 43200
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      RootRegion                  = data.aws_region.current.name
    }
  )
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.crowdstrike_aws_dspm_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy" "crowdstrike_cloud_scan_supplemental" {
  name   = "CrowdStrikeCloudScanSupplemental"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_cloud_scan_supplemental_data.json
}

data "aws_iam_policy_document" "crowdstrike_cloud_scan_supplemental_data" {
  #checkov:skip=CKV_AWS_356:DSPM cloud scanning requires read access to various AWS resources
  statement {
    sid = "CloudScanSupplemental"
    actions = [
      "ses:DescribeActiveReceiptRuleSet",
      "athena:GetWorkGroup",
      "logs:DescribeLogGroups",
      "elastictranscoder:ListPipelines",
      "elasticfilesystem:DescribeFileSystems",
      "redshift:List*",
      "redshift:Describe*",
      "redshift:View*",
      "redshift-serverless:List*",
      "ec2:GetConsoleOutput",
      "ec2:Describe*",
      "sts:DecodeAuthorizationMessage",
      "elb:DescribeLoadBalancers",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "pricing:GetProducts"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "crowdstrike_run_data_scanner_restricted" {
  count  = local.is_host_account ? 1 : 0
  name   = "RunDataScannerRestricted"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_run_data_scanner_restricted_data[0].json
}

data "aws_iam_policy_document" "crowdstrike_run_data_scanner_restricted_data" {
  count = local.is_host_account ? 1 : 0
  # Grants permission to start, terminate EC2 and attach, detach, delete volume
  # on CrowdStrike EC2 instance
  #checkov:skip=CKV_AWS_108:Running a DSPM data scanner requires ssm:GetParameters permissions
  statement {
    sid = "AllowInstanceOperationsWithRestrictions"
    actions = [
      "ec2:StartInstances",
      "ec2:TerminateInstances",
      "ec2:RebootInstances"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to launch EC2 from public image
  # Below resources are generic as they are not known during launch
  statement {
    sid = "AllowRunDistrosInstances"
    actions = [
      "ec2:RunInstances"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*::image/*",
      "arn:aws:ec2:*::snapshot/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:network-interface/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*"
    ]
  }

  # Grants permission to Launch EC2 and create volume for CrowdStrike EC2 instance
  # The condition key aws:RequestTag is applicable to below resources
  statement {
    sid = "AllowRunInstancesWithRestrictions"
    actions = [
      "ec2:RunInstances"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to Launch EC2 for CrowdStrike EC2 instance  
  # The condition key ec2:ResourceTag is applicable to below resources
  statement {
    sid    = "AllowRunInstances"
    effect = "Allow"

    actions = [
      "ec2:RunInstances"
    ]

    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:subnet/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to create below resources with only Crowdstrike tag
  # On CrowdStrike EC2 instance
  statement {
    sid = "AllowCreateTagsOnlyLaunching"
    actions = [
      "ec2:CreateTags"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["RunInstances"]
    }
  }

  # Grant permissions to attach instance profile for EC2 service created by CrowdStrike.
  statement {
    sid = "passRoleToEc2Service"
    actions = [
      "iam:PassRole"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.dspm_scanner_role_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid = "ssmAmiAliasPermissions"
    actions = [
      "ssm:GetParameters"
    ]
    effect    = "Allow"
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

resource "aws_iam_role_policy" "crowdstrike_rds_clone" {
  count  = var.dspm_rds_access ? 1 : 0
  name   = "CrowdStrikeRDSClone"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_rds_clone_base[0].json
}

resource "aws_iam_role_policy" "crowdstrike_rds_clone_host" {
  count  = (var.dspm_rds_access && local.is_host_account) ? 1 : 0
  name   = "CrowdStrikeRDSCloneHost"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_rds_clone_host[0].json
}

resource "aws_iam_role_policy" "crowdstrike_rds_clone_target" {
  count  = (var.dspm_rds_access && !local.is_host_account) ? 1 : 0
  name   = "CrowdStrikeRDSCloneTarget"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_rds_clone_target[0].json
}

# Base RDS policy - common permissions for both host and target accounts
data "aws_iam_policy_document" "crowdstrike_rds_clone_base" {
  count = var.dspm_rds_access ? 1 : 0
  
  # Grants permission to restore CMK encrypted instances
  statement {
    sid = "KMSPermissionsForRDSRestore"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["rds.*.amazonaws.com"]
    }
  }

  # Grants permission to create snapshot with a tag mentioned in the condition.
  statement {
    sid = "RDSLimitedPermissionForSnapshotCreate"
    actions = [
      "rds:CreateDBSnapshot",
      "rds:CreateDBClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:crowdstrike-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }
}

# Host account RDS policy - full permissions for scanning infrastructure
data "aws_iam_policy_document" "crowdstrike_rds_clone_host" {
  count = (var.dspm_rds_access && local.is_host_account) ? 1 : 0

  # Grants permission to add only requested tag mentioned in condition to RDS instance and snapshot
  statement {
    sid = "RDSPermissionForTagging"
    actions = [
      "rds:AddTagsToResource"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:crowdstrike-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to restore an instance/cluster from any snapshot
  statement {
    sid = "RDSPermissionForInstanceRestore"
    actions = [
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBClusterFromSnapshot",
      "kms:Decrypt" # Require to restore encrypted db snapshot using KMS keys
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:*",
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

  # Restricts permission to restore an instance/cluster to CrowdStrike VPC
  statement {
    sid = "RDSPermissionForInstanceRestoreCrowdStrikeVPC"
    actions = [
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBClusterFromSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:subgrp:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to restore instance/cluster with a tag mentioned in the condition
  statement {
    sid = "RDSLimitedPermissionForInstanceRestore"
    actions = [
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBClusterFromSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:og:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:pg:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-og:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-pg:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to copy snapshot with a tag mentioned in the condition.
  statement {
    sid = "RDSLimitedPermissionForCopySnapshot"
    actions = [
      "rds:CopyDBSnapshot",
      "rds:CopyDBClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:*:snapshot:*",
      "arn:aws:rds:*:*:cluster-snapshot:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to create db instance with a tag mentioned in the condition inside db cluster
  statement {
    sid = "RDSPermissionDBClusterCreateInstance"
    actions = [
      "rds:CreateDBInstance"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Restricts create db instance permission to CrowdStrike VPC
  statement {
    sid = "RDSPermissionDBClusterCreateInstanceCrowdStrikeVPC"
    actions = [
      "rds:CreateDBInstance"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:subgrp:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to delete or modify RDS DB/cluster, which are tagged as mentioned in the condition
  statement {
    sid = "RDSPermissionDeleteRestorePermissions"
    actions = [
      "rds:DeleteDBInstance",
      "rds:DeleteDBSnapshot",
      "rds:ModifyDBInstance",
      "rds:DeleteDBCluster",
      "rds:DeleteDBClusterSnapshot",
      "rds:ModifyDBCluster",
      "rds:RebootDBInstance"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:og:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:pg:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-og:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-pg:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }
}

# Target account RDS policy - limited permissions for sharing snapshots
data "aws_iam_policy_document" "crowdstrike_rds_clone_target" {
  count = (var.dspm_rds_access && !local.is_host_account) ? 1 : 0

  # Grants permission to add only requested tag mentioned in condition to RDS instance and snapshot
  statement {
    sid = "RDSPermissionForTagging"
    actions = [
      "rds:AddTagsToResource"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:crowdstrike-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to delete or modify RDS DB/cluster, which are tagged as mentioned in the condition
  statement {
    sid = "RDSPermissionDeleteRestorePermissions"
    actions = [
      "rds:DeleteDBSnapshot",
      "rds:DeleteDBClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to copy snapshot with a tag mentioned in the condition.
  statement {
    sid = "RDSLimitedPermissionForCopySnapshot"
    actions = [
      "rds:CopyDBSnapshot",
      "rds:CopyDBClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }

  # Grants permission to modify snapshot attributes for sharing
  statement {
    sid = "RDSLimitedPermissionForShareSnapshot"
    actions = [
      "rds:ModifyDBSnapshotAttribute",
      "rds:ModifyDBClusterSnapshotAttribute"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:snapshot:crowdstrike-*",
      "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:cluster-snapshot:crowdstrike-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${local.crowdstrike_tag_key}"
      values   = [local.crowdstrike_tag_value]
    }
  }
}

resource "aws_iam_role_policy" "crowdstrike_redshift_clone_host" {
  count  = (var.dspm_redshift_access && local.is_host_account) ? 1 : 0
  name   = "CrowdStrikeRedshiftClone"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_redshift_clone_host[0].json
}

resource "aws_iam_role_policy" "crowdstrike_redshift_clone_target" {
  count  = (var.dspm_redshift_access && !local.is_host_account) ? 1 : 0
  name   = "CrowdStrikeRedshiftCloneTarget"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_redshift_clone_target[0].json
}

# Host account Redshift policy - full permissions for scanning infrastructure
data "aws_iam_policy_document" "crowdstrike_redshift_clone_host" {
  count = (var.dspm_redshift_access && local.is_host_account) ? 1 : 0
  
  # Grants permission to create a cluster snapshot and restore cluster from snapshot
  statement {
    sid = "RedshiftPermissionsForRestoring"
    actions = [
      "redshift:RestoreFromClusterSnapshot",
      "redshift:CreateClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:snapshot:*"
    ]
  }

  # Grants permission to create tags, modify and delete CrowdStrike's clusters and snapshots
  statement {
    sid = "RedshiftPermissionsForControllingClones"
    actions = [
      "redshift:CreateTags",
      "redshift:ModifyCluster*",
      "redshift:DeleteCluster",
      "redshift:DeleteClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:cluster:crowdstrike-*",
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:snapshot:*/crowdstrike-snapshot-*"
    ]
  }

  # Grants permission to secret manager to restore redshift's password managed by secret manager
  statement {
    sid = "RedshiftPermissionsForSecretsManager"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:DescribeSecret"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:*"
    ]
  }
}

# Target account Redshift policy - limited permissions for sharing snapshots
data "aws_iam_policy_document" "crowdstrike_redshift_clone_target" {
  count = (var.dspm_redshift_access && !local.is_host_account) ? 1 : 0

  # Grants permission to create a cluster snapshot
  statement {
    sid = "RedshiftPermissionsForRestoring"
    actions = [
      "redshift:CreateClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:snapshot:*"
    ]
  }

  # Grants permission to create tags and delete CrowdStrike's snapshots
  statement {
    sid = "RedshiftPermissionsForControllingClones"
    actions = [
      "redshift:CreateTags",
      "redshift:DeleteClusterSnapshot"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:cluster:crowdstrike-*",
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:snapshot:*/crowdstrike-snapshot-*"
    ]
  }

  # Grants permission to authorize and revoke snapshot access
  statement {
    sid = "RDSAuthorizeSnapshotAccessPermissions"
    actions = [
      "redshift:AuthorizeSnapshotAccess",
      "redshift:RevokeSnapshotAccess"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:snapshot:*"
    ]
  }
}

resource "aws_iam_role_policy" "crowdstrike_ssm_reader" {
  name   = "CrowdStrikeSSMReader"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_ssm_reader_data.json
}

data "aws_iam_policy_document" "crowdstrike_ssm_reader_data" {
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/CrowdStrike/*"
    ]
  }
}

# Custom VPC IAM policy
resource "aws_iam_role_policy" "run_data_scanner_custom_vpcs" {
  count  = var.agentless_scanning_use_custom_vpc && length(var.agentless_scanning_custom_vpc_resources_map) > 0 ? 1 : 0
  name   = "RunDataScannerCustomVPCs"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.run_data_scanner_custom_vpcs_data[0].json
}

data "aws_iam_policy_document" "run_data_scanner_custom_vpcs_data" {
  count = var.agentless_scanning_use_custom_vpc && length(var.agentless_scanning_custom_vpc_resources_map) > 0 ? 1 : 0

  # Grants permission to Launch EC2 for CrowdStrike EC2 instance in custom VPCs
  # The condition key ec2:Vpc is applicable to custom VPC resources
  statement {
    sid = "AllowRunInstancesCustomVpc"
    actions = [
      "ec2:RunInstances"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:subnet/*"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "ec2:Vpc"
      values   = local.custom_vpc_arns
    }
  }
}
