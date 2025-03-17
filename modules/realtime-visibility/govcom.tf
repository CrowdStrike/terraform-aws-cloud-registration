resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  bucket_name = "crowdstrike-s3-${random_string.suffix.result}"
}

resource "aws_iam_role" "lambda" {
  count = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  name  = "CrowdStrikeCSPMLambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Sid = ""
      }
    ]
  })
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "lambda_logging" {
  count = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  name  = "logging"
  role  = aws_iam_role.lambda[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/lambda/cs-lambda-*",
          "arn:aws:logs:*:*:log-group:/aws/lambda/cs-lambda-*:log-stream:*"
        ]
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "eventbridge_logs" {
  count             = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  name              = "/aws/lambda/cs-lambda-eventbridge"
  retention_in_days = 1
}

resource "aws_lambda_function" "eventbridge" {
  count         = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  function_name = "cs-lambda-eventbridge"
  role          = aws_iam_role.lambda[0].arn
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["x86_64"]
  memory_size   = 128
  timeout       = 15
  package_type  = "Zip"

  s3_bucket = "cs-horizon-ioa-lambda-${local.aws_region}"
  s3_key    = "aws/aws-lambda-eventbridge.zip"

  environment {
    variables = {
      CS_CLIENT_ID     = var.falcon_client_id
      CS_CLIENT_SECRET = var.falcon_client_secret
      CS_GOV_CLOUD     = "true"
    }
  }

  depends_on = [aws_cloudwatch_log_group.eventbridge_logs]
}

resource "aws_lambda_alias" "eventbridge" {
  count            = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  name             = "cs-lambda-eventbridge"
  function_version = "$LATEST"
  function_name    = aws_lambda_function.eventbridge[0].arn
}

resource "aws_lambda_permission" "eventbridge" {
  count         = var.is_gov_commercial && var.is_primary_region ? 1 : 0
  function_name = aws_lambda_alias.eventbridge[0].function_name
  qualifier     = aws_lambda_alias.eventbridge[0].name
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:${local.aws_region}:${local.account_id}:rule/cs-*"
}

resource "aws_cloudwatch_log_group" "s3_logs" {
  count             = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  name              = "/aws/lambda/cs-lambda-s3"
  retention_in_days = 1
}

resource "aws_lambda_function" "s3" {
  count         = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  function_name = "cs-lambda-s3"
  role          = aws_iam_role.lambda[0].arn
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["x86_64"]
  memory_size   = 128
  timeout       = 15
  package_type  = "Zip"

  s3_bucket = "cs-horizon-ioa-lambda-${local.aws_region}"
  s3_key    = "aws/aws-lambda-s3.zip"

  environment {
    variables = {
      CS_CLIENT_ID     = var.falcon_client_id
      CS_CLIENT_SECRET = var.falcon_client_secret
      CS_GOV_CLOUD     = "true"
    }
  }

  depends_on = [aws_cloudwatch_log_group.s3_logs]
}

resource "aws_lambda_alias" "s3" {
  count            = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  name             = "cs-lambda-s3"
  function_version = "$LATEST"
  function_name    = aws_lambda_function.s3[0].arn
}

resource "aws_lambda_permission" "s3" {
  count         = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  function_name = aws_lambda_alias.s3[0].function_name
  qualifier     = aws_lambda_alias.s3[0].name
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${local.bucket_name}"
}

resource "aws_s3_bucket" "s3" {
  count         = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket        = local.bucket_name
  force_destroy = true

  depends_on = [
    aws_lambda_permission.s3
  ]
}

resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  count  = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id
  rule {
    id     = "rule-1"
    status = "Enabled"
    filter {
      prefix = ""
    }
    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_notification" "s3" {
  count  = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id

  lambda_function {
    lambda_function_arn = aws_lambda_alias.s3[0].arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.s3
  ]
}

resource "aws_s3_bucket_ownership_controls" "s3" {
  count  = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3" {
  count  = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.s3]
}

resource "aws_s3_bucket_policy" "s3" {
  count  = var.is_gov_commercial && !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${aws_s3_bucket.s3[0].id}"
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.s3[0].id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}
