data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.name
  aws_partition = data.aws_partition.current.partition
}


# Data resource to be used as the assume role policy below.
data "aws_iam_policy_document" "management" {
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

resource "aws_iam_role" "management" {
  name                 = "CrowdStrikeSensorManagement"
  assume_role_policy   = data.aws_iam_policy_document.management.json
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "invoke_lambda" {
  name = "sensor-management-invoke-orchestrator-lambda"
  role = aws_iam_role.management.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "lambda:InvokeAsync"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.aws_partition}:lambda:*:${local.account_id}:function:cs-*"
        Sid      = "InvokeLambda"
      },
      {
        Action = [
          "ssm:GetDocument",
          "ssm:GetCommandInvocation",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "orchestrator" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "orchestrator" {
  name                 = "CrowdStrikeSensorManagementOrchestrator"
  assume_role_policy   = data.aws_iam_policy_document.orchestrator.json
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "orchestrator" {
  name = "sensor-management-orchestrator-lambda-ssm-send-command"
  role = aws_iam_role.orchestrator.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:SendCommand"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ssm:*:*:document/*",
          "arn:aws:ec2:*:*:instance/*"
        ]
      },
      {
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/lambda/cs-*",
          "arn:aws:logs:*:*:log-group:/aws/lambda/cs-*:log-stream:*"
        ]
        Sid = "Logging"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:${local.aws_region}:${local.account_id}:secret:/CrowdStrike/CSPM/SensorManagement/FalconAPICredentials-??????"
        Sid      = "GetFalconCredentials"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "crowdstrike_sensor_management" {
  name              = "/aws/lambda/cs-horizon-sensor-installation-orchestrator"
  retention_in_days = 1
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "/CrowdStrike/CSPM/SensorManagement/FalconAPICredentials"
  description             = "Falcon API credentials. Used by the 1-Click sensor management orchestrator"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    ClientSecret = var.falcon_client_secret
  })
}

resource "aws_lambda_function" "this" {
  function_name = "cs-horizon-sensor-installation-orchestrator"
  role          = aws_iam_role.orchestrator.arn
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["x86_64"]
  memory_size   = 128
  timeout       = 900
  package_type  = "Zip"

  s3_bucket = "cs-horizon-sensormgmt-lambda-${local.aws_region}"
  s3_key    = "aws/horizon-sensor-installation-orchestrator.zip"

  environment {
    variables = {
      CS_CLIENT_ID                  = var.falcon_client_id
      CS_API_CREDENTIALS_AWS_SECRET = "/CrowdStrike/CSPM/SensorManagement/FalconAPICredentials"
      CS_MODE                       = "force_auth"
    }
  }

  depends_on = [aws_cloudwatch_log_group.crowdstrike_sensor_management]
}
