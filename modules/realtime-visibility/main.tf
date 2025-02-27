data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id        = data.aws_caller_identity.current.account_id
  aws_region        = data.aws_region.current.name
  aws_partition     = data.aws_partition.current.partition
  is_gov_commercial = var.is_gov && local.aws_partition == "aws"
}

resource "aws_iam_role" "this" {
  name = var.role_name
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
        "Resource" : !local.is_gov_commercial ? "arn:${local.aws_partition}:events:*:*:event-bus/cs-*" : "arn:aws:events:*:*:event-bus/default"
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_cloudtrail" "this" {
  count                         = var.use_existing_cloudtrail ? 0 : 1
  name                          = "crowdstrike-cloudtrail"
  s3_bucket_name                = !local.is_gov_commercial ? var.cloudtrail_bucket_name : aws_s3_bucket.s3.0.bucket
  s3_key_prefix                 = ""
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  is_organization_trail         = var.is_organization_trail
}

