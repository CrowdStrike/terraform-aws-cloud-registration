data "aws_caller_identity" "current" {}

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
      "sts:DecodeAuthorizationMessage",
      "elb:DescribeLoadBalancers",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "crowdstrike_run_data_scanner_restricted" {
  name   = "CrowdStrikeRunDataScannerRestricted"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_run_data_scanner_restricted_data.json
}

data "aws_iam_policy_document" "crowdstrike_run_data_scanner_restricted_data" {
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
      join("/", [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role",
      var.dspm_scanner_role_name])
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
    resources = ["arn:aws:ssm:*:*:parameter/aws/service/ami-amazon-linux-latest/*"]
  }
}

resource "aws_iam_role_policy" "crowdstrike_rds_clone" {
  name   = "CrowdStrikeRDSClone"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_rds_clone_data.json
}

data "aws_iam_policy_document" "crowdstrike_rds_clone_data" {
  # Grants permission to add only requested tag mentioned in condition to RDS instance and snapshot.
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

  # Grants permission to restore an instance/cluster from any snapshot
  statement {
    sid = "RDSPermissionForInstanceRestore"
    actions = [
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBClusterFromSnapshot",
      "kms:Decrypt" #  Require to restore encrypted db snapshot using KMS keys
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

resource "aws_iam_role_policy" "crowdstrike_redshift_clone" {
  name   = "CrowdStrikeRedshiftClone"
  role   = aws_iam_role.crowdstrike_aws_dspm_integration_role.id
  policy = data.aws_iam_policy_document.crowdstrike_redshift_clone.json
}

data "aws_iam_policy_document" "crowdstrike_redshift_clone" {
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

  # Grants permission to secret manager to restore redshfit's password managed by secret manager
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
