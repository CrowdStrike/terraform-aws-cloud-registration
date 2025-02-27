data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  aws_partition = data.aws_partition.current.partition
}

# Data resource to be used as the assume role policy below.
data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.intermediate_role_arn]
    }
    condition {
      test     = "StringEquals"
      values   = [var.external_id]
      variable = "sts:ExternalId"
    }
  }
}

# Create IAM role policy giving the CrowdStrike IAM role read access to AWS resources.
resource "aws_iam_role" "this" {
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.this.json
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "this" {
  name = "cspm_config"
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "lambda:GetLayerVersion",
          "backup:ListBackupPlans",
          "backup:ListRecoveryPointsByBackupVault",
          "ecr:GetRegistryScanningConfiguration",
          "eks:ListFargateProfiles",
          "eks:Describe*",
          "elasticfilesystem:DescribeAccessPoints",
          "lambda:GetFunction",
          "sns:GetSubscriptionAttributes",
          "backup:DescribeBackupVault",
          "backup:DescribeRecoveryPoint"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "arn:${data.aws_partition.current.partition}:apigateway:*::/restapis/*"
        Action = [
          "apigateway:Get"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/SecurityAudit"
}

