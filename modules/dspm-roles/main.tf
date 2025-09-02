# Creates instance profile. Attached as IAM role to EC2 instance, used for data scan
resource "aws_iam_instance_profile" "instance_profile" {
  name = "CrowdStrikeScannerRoleProfile"
  path = "/"
  role = var.dspm_scanner_role_name
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
    permissions = {
      s3_policy       = var.dspm_s3_access ? "${var.dspm_scanner_role_name}/CrowdStrikeBucketReader" : "null"
      rds_policy      = var.dspm_rds_access ? "${var.dspm_role_name}/CrowdStrikeRDSClone" : "null"
      dynamodb_policy = var.dspm_dynamodb_access ? "${var.dspm_scanner_role_name}/CrowdStrikeDynamoDBReader" : "null"
      redshift_policy = var.dspm_redshift_access ? "${var.dspm_role_name}/CrowdStrikeRedshiftClone" : "null"
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

resource "aws_iam_role" "crowdstrike_aws_dspm_scanner_role" {
  name = var.dspm_scanner_role_name
  path = "/"
  assume_role_policy = jsonencode({
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
  })
  tags = merge(
    var.tags,
    {
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_iam_role_policy_attachment" "cloud_watch_logs_read_only_access" {
  role       = aws_iam_role.crowdstrike_aws_dspm_scanner_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}


resource "aws_iam_role_policy" "crowdstrike_logs_reader" {
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to logs for all scannable assets
  name = "CrowdStrikeLogsReader"
  role = aws_iam_role.crowdstrike_aws_dspm_scanner_role.id
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
  count = var.dspm_s3_access ? 1 : 0
  #checkov:skip=CKV_AWS_288,CKV_AWS_355:DSPM data scanner requires read access to all scannable s3 assets
  name = "CrowdStrikeBucketReader"
  role = aws_iam_role.crowdstrike_aws_dspm_scanner_role.id
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
  count = var.dspm_dynamodb_access ? 1 : 0
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to all scannable dynamodb assets
  name = "CrowdStrikeDynamoDBReader"
  role = aws_iam_role.crowdstrike_aws_dspm_scanner_role.id
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
  count = var.dspm_redshift_access ? 1 : 0
  #checkov:skip=CKV_AWS_355:DSPM data scanner requires read access to all scannable redshift assets
  #checkov:skip=CKV_AWS_290,CKV_AWS_287:DSPM data scanner requires redshift:Get* permissions
  name = "CrowdStrikeRedshiftReader"
  role = aws_iam_role.crowdstrike_aws_dspm_scanner_role.id
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
  name = "CrowdStrikeSecretReader"
  role = aws_iam_role.crowdstrike_aws_dspm_scanner_role.id
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
