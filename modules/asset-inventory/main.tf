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
          "athena:GetDataCatalog",
          "auditmanager:GetAssessment",
          "auditmanager:GetControl",
          "backup:DescribeBackupVault",
          "backup:DescribeRecoveryPoint",
          "backup:ListBackupPlans",
          "backup:ListRecoveryPointsByBackupVault",
          "batch:DescribeJobQueues",
          "bedrock:GetAgent",
          "bedrock:GetAgentActionGroup",
          "bedrock:GetAgentAlias",
          "bedrock:GetAgentCollaborator",
          "bedrock:GetAgentKnowledgeBase",
          "bedrock:GetAgentMemory",
          "bedrock:GetAgentVersion",
          "bedrock:GetFoundationModel",
          "bedrock:GetFoundationModelAvailability",
          "bedrock:GetGuardrail",
          "bedrock:GetKnowledgeBase",
          "bedrock:GetKnowledgeBaseDocuments",
          "bedrock:GetModelCustomizationJob",
          "bedrock:GetProvisionedModelThroughput",
          "bedrock:ListAgentActionGroups",
          "bedrock:ListAgentAliases",
          "bedrock:ListAgentCollaborators",
          "bedrock:ListAgentKnowledgeBases",
          "bedrock:ListAgentVersions",
          "bedrock:ListAgents",
          "bedrock:ListFoundationModelAgreementOffers",
          "bedrock:ListFoundationModels",
          "bedrock:ListGuardrails",
          "bedrock:ListKnowledgeBaseDocuments",
          "bedrock:ListKnowledgeBases",
          "bedrock:ListModelCustomizationJobs",
          "bedrock:ListProvisionedModelThroughputs",
          "cognito-idp:GetGroup",
          "cognito-idp:GetLogDeliveryConfiguration",
          "detective:ListDatasourcePackages",
          "detective:ListTagsForResource",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRegistryScanningConfiguration",
          "eks:Describe*",
          "eks:ListFargateProfiles",
          "elasticfilesystem:DescribeAccessPoints",
          "fms:GetAdminAccount",
          "fms:GetPolicy",
          "fms:ListAdminAccountsForOrganization",
          "grafana:DescribeWorkspace",
          "grafana:DescribeWorkspaceAuthentication",
          "grafana:DescribeWorkspaceConfiguration",
          "lambda:GetEventSourceMapping",
          "lambda:GetFunction",
          "lambda:GetLayerVersion",
          "lightsail:GetBucketAccessKeys",
          "lightsail:GetContainerServiceDeployments",
          "lightsail:GetContainerServiceMetricData",
          "lightsail:GetDisk",
          "lightsail:GetInstance",
          "lightsail:GetInstanceAccessDetails",
          "lightsail:GetInstancePortStates",
          "lightsail:GetInstanceState",
          "lightsail:GetKeyPair",
          "lightsail:GetKeyPairs",
          "memorydb:DescribeACLs",
          "memorydb:DescribeParameters",
          "memorydb:DescribeParameterGroups",
          "memorydb:DescribeSnapshots",
          "memorydb:DescribeSubnetGroups",
          "memorydb:DescribeUsers",
          "memorydb:ListTags",
          "sns:GetSubscriptionAttributes",
          "waf-regional:GetIPSet",
          "waf-regional:GetRule",
          "waf-regional:GetRuleGroup",
          "waf-regional:ListActivatedRulesInRuleGroup",
          "waf-regional:ListIPSets",
          "waf-regional:ListRuleGroups",
          "waf-regional:ListRules",
          "wafv2:GetIPSet",
          "wafv2:GetRuleGroup"
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
