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
  count                = !var.use_existing_iam_reader_role ? 1 : 0
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.this.json
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
  tags                 = var.tags
}

resource "aws_iam_role_policy" "this" {
  name  = "cspm_config"
  count = !var.use_existing_iam_reader_role ? 1 : 0
  role  = aws_iam_role.this[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "aoss:BatchGetCollection",
          "aoss:ListCollections",
          "appsync:GetApiCache",
          "appsync:GetGraphqlApi",
          "appsync:GetGraphqlApiEnvironmentVariables",
          "appsync:GetIntrospectionSchema",
          "athena:GetDataCatalog",
          "auditmanager:GetAssessment",
          "auditmanager:GetControl",
          "backup:DescribeBackupVault",
          "backup:DescribeRecoveryPoint",
          "backup:GetBackupPlan",
          "backup:GetBackupSelection",
          "backup:ListBackupPlans",
          "backup:ListBackupSelections",
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
          "cassandra:Select",
          "cloudformation:GetTemplateSummary",
          "codeartifact:DescribeDomain",
          "codeartifact:DescribeRepository",
          "codeartifact:ListDomains",
          "codeartifact:ListRepositoriesInDomain",
          "codeartifact:ListTagsForResource",
          "codeguru-profiler:DescribeProfilingGroup",
          "codeguru-profiler:ListProfilingGroups",
          "codepipeline:ListPipelineExecutions",
          "codepipeline:ListRuleExecutions",
          "codepipeline:ListTagsForResource",
          "codepipeline:ListWebhooks",
          "cognito-idp:GetGroup",
          "cognito-idp:GetLogDeliveryConfiguration",
          "detective:ListDatasourcePackages",
          "detective:ListTagsForResource",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRegistryScanningConfiguration",
          "elasticfilesystem:DescribeAccessPoints",
          "fms:GetAdminAccount",
          "fms:GetPolicy",
          "fms:ListAdminAccountsForOrganization",
          "glue:GetBlueprint",
          "glue:GetConnection",
          "glue:GetConnections",
          "glue:GetCrawler",
          "glue:GetDatabase",
          "glue:GetDevEndpoint",
          "glue:GetJob",
          "glue:GetResourcePolicies",
          "glue:GetSchema",
          "glue:GetTrigger",
          "glue:GetTriggers",
          "glue:ListBlueprints",
          "glue:ListSchemas",
          "grafana:DescribeWorkspace",
          "grafana:DescribeWorkspaceAuthentication",
          "grafana:DescribeWorkspaceConfiguration",
          "imagebuilder:GetComponent",
          "imagebuilder:GetImagePipeline",
          "imagebuilder:GetImageRecipe",
          "imagebuilder:GetInfrastructureConfiguration",
          "imagebuilder:ListComponents",
          "imagebuilder:ListImagePipelines",
          "imagebuilder:ListImageRecipes",
          "imagebuilder:ListInfrastructureConfigurations",
          "imagebuilder:ListTagsForResource",
          "lambda:GetEventSourceMapping",
          "lambda:GetFunction",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:GetFunctionUrlConfig",
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
          "lightsail:GetRelationalDatabase",
          "lightsail:GetRelationalDatabases",
          "macie2:DescribeClassificationJob",
          "macie2:GetMacieSession",
          "macie2:ListClassificationJobs",
          "macie2:ListTagsForResource",
          "memorydb:DescribeACLs",
          "memorydb:DescribeParameterGroups",
          "memorydb:DescribeParameters",
          "memorydb:DescribeSnapshots",
          "memorydb:DescribeSubnetGroups",
          "memorydb:DescribeUsers",
          "memorydb:ListTags",
          "sns:GetSubscriptionAttributes",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "states:DescribeActivity",
          "states:DescribeStateMachineForExecution",
          "states:ListActivities",
          "states:ListStateMachineAliases",
          "states:ListStateMachineVersions",
          "states:ListTagsForResource",
          "waf-regional:GetIPSet",
          "waf-regional:GetRule",
          "waf-regional:GetRuleGroup",
          "waf-regional:ListActivatedRulesInRuleGroup",
          "waf-regional:ListIPSets",
          "waf-regional:ListRuleGroups",
          "waf-regional:ListRules",
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
  count      = !var.use_existing_iam_reader_role ? 1 : 0
  role       = aws_iam_role.this[count.index].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/SecurityAudit"
}
