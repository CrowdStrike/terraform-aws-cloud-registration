# Creates instance profile. Attached as IAM role to EC2 instance, used for data scan
resource "aws_iam_instance_profile" "instance_profile" {
  count = local.is_host_account ? 1 : 0
  name  = "CrowdStrikeScannerRoleProfile"
  path  = "/"
  role  = var.agentless_scanning_scanner_role_name
  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_ssm_parameter" "agentless_scanning_root_parameter" {
  name = "/CrowdStrike/AgentlessScanning/Root"
  type = "String"
  tier = "Intelligent-Tiering"
  value = jsonencode({
    version            = "1.0.0+tf.2"
    deployment_regions = var.agentless_scanning_regions
    scan_products = {
      dspm_scanning_enabled          = var.enable_dspm
      vulnerability_scanning_enabled = var.enable_vulnerability_scanning
    }
    scanner_role_arn = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.arn
    instance_profile = local.is_host_account ? aws_iam_instance_profile.instance_profile[0].name : ""
    host_account_id  = local.is_host_account ? data.aws_caller_identity.current.account_id : var.agentless_scanning_host_account_id
    permissions = {
      s3_policy       = local.create_s3_policy ? "${var.agentless_scanning_scanner_role_name}/CrowdStrikeBucketReader" : ""
      rds_policy      = local.create_rds_policy ? "${var.agentless_scanning_role_name}/CrowdStrikeRDSClone" : ""
      dynamodb_policy = local.create_dynamodb_policy ? "${var.agentless_scanning_scanner_role_name}/CrowdStrikeDynamoDBReader" : ""
      redshift_policy = local.create_redshift_policy ? "${var.agentless_scanning_role_name}/CrowdStrikeRedshiftClone" : ""
      ebs_policy      = local.create_ebs_policy ? "${var.agentless_scanning_role_name}/CrowdStrikeEBSClone" : ""
    }
  })
  description = "Tracks which datastore services are enabled for DSPM scanning via their policies"
  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_iam_role" "crowdstrike_aws_agentless_scanning_scanner_role" {
  name = var.agentless_scanning_scanner_role_name
  path = "/"
  assume_role_policy = local.is_host_account ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    }) : jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.agentless_scanning_host_account_id}:role/${var.agentless_scanning_host_scanner_role_name}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

moved {
  from = aws_iam_role.crowdstrike_aws_dspm_scanner_role
  to   = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role
}

resource "aws_iam_role_policy_attachment" "cloud_watch_logs_read_only_access" {
  role       = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}


resource "aws_iam_role_policy" "crowdstrike_logs_reader" {
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to logs for all scannable assets
  name = "CrowdStrikeLogsReader"
  role = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DownloadDBLogFilePortion",
          "rds:DownloadCompleteDBLogFile",
          "rds:DescribeDBLogFiles",
          "logs:ListTagsLogGroup",
          "logs:DescribeQueries",
          "logs:GetLogRecord",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:DescribeSubscriptionFilters",
          "logs:StartQuery",
          "logs:DescribeMetricFilters",
          "logs:StopQuery",
          "logs:TestMetricFilter",
          "logs:GetLogDelivery",
          "logs:ListLogDeliveries",
          "logs:DescribeExportTasks",
          "logs:GetQueryResults",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:DescribeQueryDefinitions",
          "logs:GetLogGroupFields",
          "logs:DescribeResourcePolicies",
          "logs:DescribeDestinations"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy" "crowdstrike_bucket_reader" {
  count = local.create_s3_policy ? 1 : 0
  #checkov:skip=CKV_AWS_288,CKV_AWS_355:DSPM data scanner requires read access to all scannable s3 assets
  name = "CrowdStrikeBucketReader"
  role = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowS3ReadObjects"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Sid      = "AllowS3DecryptObjects"
        Action   = "kms:Decrypt"
        Effect   = "Allow",
        Resource = ["*"]
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.*.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "crowdstrike_dynamodb_reader" {
  count = local.create_dynamodb_policy ? 1 : 0
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to all scannable dynamodb assets
  name = "CrowdStrikeDynamoDBReader"
  role = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PartiQLSelect"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy" "crowdstrike_redshift_reader" {
  count = (local.create_redshift_policy && local.is_host_account) ? 1 : 0
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to all scannable redshift assets
  #checkov:skip=CKV_AWS_290,CKV_AWS_287:DSPM data scanner requires redshift:Get* permissions
  name = "CrowdStrikeRedshiftReader"
  role = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "redshift:List*",
          "redshift:Describe*",
          "redshift:View*",
          "redshift:Get*",
          "redshift-serverless:List*",
          "redshift-serverless:Get*"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy" "crowdstrike_secret_reader" {
  count = local.is_host_account ? 1 : 0
  name  = "CrowdStrikeSecretReader"
  role  = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SecretsManagerReadClientSecret"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:secretsmanager:*:*:secret:CrowdStrikeDSPMClientSecret-*"]
      },
      {
        Sid      = "SecretsManagerListSecrets",
        Action   = "secretsmanager:ListSecrets",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "crowdstrike_assume_target_scanner_role" {
  count = local.is_host_account ? 1 : 0
  name  = "CrowdStrikeAssumeTargetScannerRole"
  role  = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeRole"
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ]
        Resource = "arn:aws:iam::*:role/*"
      }
    ]
  })
}

# EBS Volume Reader Policy for EBS Scanning
resource "aws_iam_role_policy" "crowdstrike_ebs_volume_reader" {
  count = (local.create_ebs_policy && local.is_host_account) ? 1 : 0
  name  = "CrowdStrikeEBSVolumeReader"
  role  = aws_iam_role.crowdstrike_aws_agentless_scanning_scanner_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AttachEBSVolumes"
        Effect = "Allow"
        Action = [
          "ec2:AttachVolume",
          "ec2:DetachVolume"
        ]
        Resource = [
          "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*",
          "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/${local.crowdstrike_tag_key}" = local.crowdstrike_tag_value
          }
        }
      },
      {
        Sid    = "AllowDescribeVolumesAndInstanceAttributes"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeInstanceAttribute"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowUseOfKMSKeyForEBS"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:CreateGrant"
        ]
        Resource = "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        Condition = {
          StringLike = {
            "kms:ViaService" = "ec2.*.amazonaws.com"
          }
        }
      }
    ]
  })
}

