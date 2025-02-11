data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  aws_partition = data.aws_partition.current.partition
}

resource "aws_cloudtrail" "this" {
  count                         = var.use_existing_cloudtrail ? 0 : 1
  name                          = "crowdstrike-cloudtrail"
  s3_bucket_name                = var.cloudtrail_bucket_name
  s3_key_prefix                 = ""
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}

resource "aws_iam_role" "this" {
  name = "CrowdStrikeCSPMEventBridge"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "eventbridge-put-events"
  role = aws_iam_role.this.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "events:PutEvents"
        ],
        "Resource" : "arn:aws:events:*:*:event-bus/cs-*"
        "Effect" : "Allow"
      }
    ]
  })
}
