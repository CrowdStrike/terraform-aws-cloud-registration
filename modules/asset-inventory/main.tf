data "aws_partition" "current" {}

# Data resource to be used as the assume role policy below.
data "aws_iam_policy_document" "cs_iam_assume_role_policy" {
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
resource "aws_iam_role" "cs_iam_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.cs_iam_assume_role_policy.json
}

resource "aws_iam_role_policy" "cspm_config" {
  name = "cspm_config"
  role = aws_iam_role.cs_iam_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
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
          "sns:GetSubscriptionAttributes"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cs_iam_role_attach" {
  role       = aws_iam_role.cs_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/SecurityAudit"
}
