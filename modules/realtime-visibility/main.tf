data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.id
  aws_partition = data.aws_partition.current.partition

  # Conditional logic for log ingestion methods
  use_s3_method          = var.log_ingestion_method == "s3"
  use_eventbridge_method = var.log_ingestion_method == "eventbridge"
  has_kms_key            = var.log_ingestion_kms_key_arn != ""
  has_s3_prefix          = var.log_ingestion_s3_bucket_prefix != ""

  # Parse SNS topic ARN to extract account ID and region, only create S3 resources if both match current account and region
  sns_topic_account_id                           = var.log_ingestion_sns_topic_arn != "" ? split(":", var.log_ingestion_sns_topic_arn)[4] : ""
  sns_topic_region                               = var.log_ingestion_sns_topic_arn != "" ? split(":", var.log_ingestion_sns_topic_arn)[3] : ""
  use_s3_method_and_sns_topic_in_current_account = local.use_s3_method && var.log_ingestion_sns_topic_arn != "" && local.sns_topic_account_id == local.account_id
  use_s3_method_and_sns_topic_in_current_region  = local.use_s3_method && var.log_ingestion_sns_topic_arn != "" && local.sns_topic_region == local.aws_region
  use_s3_method_and_sns_topic_matches_current    = local.use_s3_method_and_sns_topic_in_current_account && local.use_s3_method_and_sns_topic_in_current_region
}

resource "aws_iam_role" "eventbridge" {
  count = local.use_eventbridge_method && var.is_primary_region ? 1 : 0
  name  = var.eventbridge_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : local.account_id
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:${local.aws_partition}:events:*:${local.account_id}:rule/*"
          }
        }
      }
    ]
  })
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
  tags                 = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  count = local.use_eventbridge_method && var.is_primary_region ? 1 : 0
  name  = "eventbridge-put-events"
  role  = aws_iam_role.eventbridge[count.index].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "events:PutEvents"
        ],
        "Resource" : !var.is_gov_commercial ? compact(split(",", var.eventbus_arn)) : ["arn:${local.aws_partition}:events:*:${local.account_id}:event-bus/default"]
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_cloudtrail" "this" {
  count                         = !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  name                          = "${var.resource_prefix}CSPMCloudtrail${var.resource_suffix}"
  s3_bucket_name                = !var.is_gov_commercial ? var.cloudtrail_bucket_name : aws_s3_bucket.s3[0].bucket
  s3_key_prefix                 = ""
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  is_organization_trail         = var.is_organization_trail
  tags                          = var.tags
}

# Dead Letter Queue for failed CloudTrail log messages
resource "aws_sqs_queue" "cloudtrail_logs_dlq" {
  count                     = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  name                      = "${var.resource_prefix}CloudTrailLogsDLQ${var.resource_suffix}"
  message_retention_seconds = 1209600 # 14 days
  tags = merge(var.tags, {
    Name = "${var.resource_prefix}CloudTrailLogsDLQ${var.resource_suffix}"
  })
}

# SQS Queue for S3-based log consumption method
resource "aws_sqs_queue" "cloudtrail_logs_sqs" {
  count                      = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  name                       = "${var.resource_prefix}CloudTrailLogsSQS${var.resource_suffix}"
  message_retention_seconds  = 1209600 # 14 days
  visibility_timeout_seconds = 300     # 5 minutes

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cloudtrail_logs_dlq[0].arn
    maxReceiveCount     = 5
  })

  tags = merge(var.tags, {
    Name = "${var.resource_prefix}CloudTrailLogsSQS${var.resource_suffix}"
  })
}

# SQS Queue Policy to allow SNS to send messages
resource "aws_sqs_queue_policy" "cloudtrail_logs_sqs_policy" {
  count     = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  queue_url = aws_sqs_queue.cloudtrail_logs_sqs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.cloudtrail_logs_sqs[0].arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.log_ingestion_sns_topic_arn
          }
        }
      }
    ]
  })
}

# SNS Subscription to link SNS topic to SQS queue
resource "aws_sns_topic_subscription" "cloudtrail_logs_sns_subscription" {
  count                = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  protocol             = "sqs"
  topic_arn            = var.log_ingestion_sns_topic_arn
  endpoint             = aws_sqs_queue.cloudtrail_logs_sqs[0].arn
  raw_message_delivery = false
}

# Cross-account IAM role for S3 log consumption
resource "aws_iam_role" "s3_log_role" {
  count = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  name  = "${var.resource_prefix}CrowdStrikeCloudTrailReader${var.resource_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.intermediate_role_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
  tags                 = var.tags

  depends_on = [
    aws_sqs_queue.cloudtrail_logs_sqs,
    aws_sqs_queue.cloudtrail_logs_dlq
  ]
}

# IAM Policy for S3-based log consumption permissions
resource "aws_iam_policy" "s3_log_consumption_policy" {
  count = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  name  = "CrowdStrikeS3LogConsumption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      # S3 permissions for CloudTrail logs
      {
        Sid    = "S3CloudTrailLogsAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = local.has_s3_prefix ? [
          "arn:${local.aws_partition}:s3:::${var.log_ingestion_s3_bucket_name}",
          "arn:${local.aws_partition}:s3:::${var.log_ingestion_s3_bucket_name}/${var.log_ingestion_s3_bucket_prefix}/*"
          ] : [
          "arn:${local.aws_partition}:s3:::${var.log_ingestion_s3_bucket_name}",
          "arn:${local.aws_partition}:s3:::${var.log_ingestion_s3_bucket_name}/*"
        ]
      },
      # SQS permissions for queue operations
      {
        Sid    = "SQSCloudTrailLogsAccess"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage"
        ]
        Resource = [
          aws_sqs_queue.cloudtrail_logs_sqs[0].arn,
          aws_sqs_queue.cloudtrail_logs_dlq[0].arn
        ]
      },
      # CloudWatch metrics permissions for SQS monitoring
      {
        Sid    = "CloudWatchSQSMetricsAccess"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      }
      ], local.has_kms_key ? [
      # KMS permissions for decryption (if KMS key provided)
      {
        Sid    = "KMSCloudTrailLogsAccess"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = var.log_ingestion_kms_key_arn
      }
    ] : [])
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "s3_log_consumption_policy_attachment" {
  count      = local.use_s3_method_and_sns_topic_matches_current ? 1 : 0
  role       = aws_iam_role.s3_log_role[0].name
  policy_arn = aws_iam_policy.s3_log_consumption_policy[0].arn
}
