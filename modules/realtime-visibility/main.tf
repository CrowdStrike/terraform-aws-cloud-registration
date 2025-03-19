data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.name
  aws_partition = data.aws_partition.current.partition
}

resource "aws_iam_role" "eventbridge" {
  count = var.is_primary_region ? 1 : 0
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
        "Sid" : ""
      }
    ]
  })
  permissions_boundary = var.permissions_boundary != "" ? "arn:${local.aws_partition}:iam::${local.account_id}:policy/${var.permissions_boundary}" : null
}

resource "aws_iam_role_policy" "inline_policy" {
  count = var.is_primary_region ? 1 : 0
  name  = "eventbridge-put-events"
  role  = aws_iam_role.eventbridge[count.index].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "events:PutEvents"
        ],
        "Resource" : !var.is_gov_commercial ? "arn:${local.aws_partition}:events:*:*:event-bus/cs-*" : "arn:aws:events:*:*:event-bus/default"
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_cloudtrail" "this" {
  count                         = !var.use_existing_cloudtrail && var.is_primary_region ? 1 : 0
  name                          = "crowdstrike-cloudtrail"
  s3_bucket_name                = !var.is_gov_commercial ? var.cloudtrail_bucket_name : aws_s3_bucket.s3[0].bucket
  s3_key_prefix                 = ""
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  is_organization_trail         = var.is_organization_trail
}
