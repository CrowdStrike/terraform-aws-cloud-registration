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

data "aws_regions" "available" {
  all_regions = true
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

locals {
  available_regions = [for region in data.aws_regions.available.names : region if !contains(var.excluded_regions, region)]
}

locals {
  target_id    = "CrowdStrikeCentralizeEvents"
  rule_name    = "cs-cloudtrail-events-ioa-rule"
  ro_rule_name = "cs-cloudtrail-events-readonly-rule"
  event_pattern = jsonencode({
    source = [
      {
        "prefix" : "aws."
      }
    ],
    detail-type = [
      {
        suffix = "via CloudTrail"
      }
    ],
    detail = {
      "eventName" : [
        {
          "anything-but" : [
            "InvokeExecution",
            "Invoke",
            "UploadPart"
          ]
        }
      ],
      "readOnly" : [
        false
      ]
    }
  })
}


resource "aws_cloudwatch_event_rule" "us-east-1" {
  count         = contains(local.available_regions, "us-east-1") && !var.is_gov ? 1 : 0
  provider      = aws.us-east-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "us-east-1" {
  count     = contains(local.available_regions, "us-east-1") && !var.is_gov ? 1 : 0
  provider  = aws.us-east-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.us-east-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "us-east-2" {
  count         = contains(local.available_regions, "us-east-2") && !var.is_gov ? 1 : 0
  provider      = aws.us-east-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "us-east-2" {
  count     = contains(local.available_regions, "us-east-2") && !var.is_gov ? 1 : 0
  provider  = aws.us-east-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.us-east-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "us-west-1" {
  count         = contains(local.available_regions, "us-west-1") && !var.is_gov ? 1 : 0
  provider      = aws.us-west-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "us-west-1" {
  count     = contains(local.available_regions, "us-west-1") && !var.is_gov ? 1 : 0
  provider  = aws.us-west-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.us-west-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "us-west-2" {
  count         = contains(local.available_regions, "us-west-2") && !var.is_gov ? 1 : 0
  provider      = aws.us-west-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "us-west-2" {
  count     = contains(local.available_regions, "us-west-2") && !var.is_gov ? 1 : 0
  provider  = aws.us-west-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.us-west-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "af-south-1" {
  count         = contains(local.available_regions, "af-south-1") && !var.is_gov ? 1 : 0
  provider      = aws.af-south-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "af-south-1" {
  count     = contains(local.available_regions, "af-south-1") && !var.is_gov ? 1 : 0
  provider  = aws.af-south-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.af-south-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-east-1" {
  count         = contains(local.available_regions, "ap-east-1") && !var.is_gov ? 1 : 0
  provider      = aws.ap-east-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-east-1" {
  count     = contains(local.available_regions, "ap-east-1") && !var.is_gov ? 1 : 0
  provider  = aws.ap-east-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-east-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-south-1" {
  count         = contains(local.available_regions, "ap-south-1") && !var.is_gov ? 1 : 0
  provider      = aws.ap-south-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-south-1" {
  count     = contains(local.available_regions, "ap-south-1") && !var.is_gov ? 1 : 0
  provider  = aws.ap-south-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-south-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-south-2" {
  count         = contains(local.available_regions, "ap-south-2") && !var.is_gov ? 1 : 0
  provider      = aws.ap-south-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-south-2" {
  count     = contains(local.available_regions, "ap-south-2") && !var.is_gov ? 1 : 0
  provider  = aws.ap-south-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-south-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-southeast-1" {
  count         = contains(local.available_regions, "ap-southeast-1") && !var.is_gov ? 1 : 0
  provider      = aws.ap-southeast-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-southeast-1" {
  count     = contains(local.available_regions, "ap-southeast-1") && !var.is_gov ? 1 : 0
  provider  = aws.ap-southeast-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-southeast-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-southeast-2" {
  count         = contains(local.available_regions, "ap-southeast-2") && !var.is_gov ? 1 : 0
  provider      = aws.ap-southeast-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-southeast-2" {
  count     = contains(local.available_regions, "ap-southeast-2") && !var.is_gov ? 1 : 0
  provider  = aws.ap-southeast-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-southeast-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-southeast-3" {
  count         = contains(local.available_regions, "ap-southeast-3") && !var.is_gov ? 1 : 0
  provider      = aws.ap-southeast-3
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-southeast-3" {
  count     = contains(local.available_regions, "ap-southeast-3") && !var.is_gov ? 1 : 0
  provider  = aws.ap-southeast-3
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-southeast-3.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-southeast-4" {
  count         = contains(local.available_regions, "ap-southeast-4") && !var.is_gov ? 1 : 0
  provider      = aws.ap-southeast-4
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-southeast-4" {
  count     = contains(local.available_regions, "ap-southeast-4") && !var.is_gov ? 1 : 0
  provider  = aws.ap-southeast-4
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-southeast-4.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-northeast-1" {
  count         = contains(local.available_regions, "ap-northeast-1") && !var.is_gov ? 1 : 0
  provider      = aws.ap-northeast-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-northeast-1" {
  count     = contains(local.available_regions, "ap-northeast-1") && !var.is_gov ? 1 : 0
  provider  = aws.ap-northeast-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-northeast-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-northeast-2" {
  count         = contains(local.available_regions, "ap-northeast-2") && !var.is_gov ? 1 : 0
  provider      = aws.ap-northeast-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-northeast-2" {
  count     = contains(local.available_regions, "ap-northeast-2") && !var.is_gov ? 1 : 0
  provider  = aws.ap-northeast-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-northeast-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ap-northeast-3" {
  count         = contains(local.available_regions, "ap-northeast-3") && !var.is_gov ? 1 : 0
  provider      = aws.ap-northeast-3
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ap-northeast-3" {
  count     = contains(local.available_regions, "ap-northeast-3") && !var.is_gov ? 1 : 0
  provider  = aws.ap-northeast-3
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ap-northeast-3.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "ca-central-1" {
  count         = contains(local.available_regions, "ca-central-1") && !var.is_gov ? 1 : 0
  provider      = aws.ca-central-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "ca-central-1" {
  count     = contains(local.available_regions, "ca-central-1") && !var.is_gov ? 1 : 0
  provider  = aws.ca-central-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.ca-central-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-central-1" {
  count         = contains(local.available_regions, "eu-central-1") && !var.is_gov ? 1 : 0
  provider      = aws.eu-central-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-central-1" {
  count     = contains(local.available_regions, "eu-central-1") && !var.is_gov ? 1 : 0
  provider  = aws.eu-central-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-central-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-west-1" {
  count         = contains(local.available_regions, "eu-west-1") && !var.is_gov ? 1 : 0
  provider      = aws.eu-west-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-west-1" {
  count     = contains(local.available_regions, "eu-west-1") && !var.is_gov ? 1 : 0
  provider  = aws.eu-west-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-west-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-west-2" {
  count         = contains(local.available_regions, "eu-west-2") && !var.is_gov ? 1 : 0
  provider      = aws.eu-west-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-west-2" {
  count     = contains(local.available_regions, "eu-west-2") && !var.is_gov ? 1 : 0
  provider  = aws.eu-west-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-west-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-west-3" {
  count         = contains(local.available_regions, "eu-west-3") && !var.is_gov ? 1 : 0
  provider      = aws.eu-west-3
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-west-3" {
  count     = contains(local.available_regions, "eu-west-3") && !var.is_gov ? 1 : 0
  provider  = aws.eu-west-3
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-west-3.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-south-1" {
  count         = contains(local.available_regions, "eu-south-1") && !var.is_gov ? 1 : 0
  provider      = aws.eu-south-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-south-1" {
  count     = contains(local.available_regions, "eu-south-1") && !var.is_gov ? 1 : 0
  provider  = aws.eu-south-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-south-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-south-2" {
  count         = contains(local.available_regions, "eu-south-2") && !var.is_gov ? 1 : 0
  provider      = aws.eu-south-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-south-2" {
  count     = contains(local.available_regions, "eu-south-2") && !var.is_gov ? 1 : 0
  provider  = aws.eu-south-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-south-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-north-1" {
  count         = contains(local.available_regions, "eu-north-1") && !var.is_gov ? 1 : 0
  provider      = aws.eu-north-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-north-1" {
  count     = contains(local.available_regions, "eu-north-1") && !var.is_gov ? 1 : 0
  provider  = aws.eu-north-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-north-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "eu-central-2" {
  count         = contains(local.available_regions, "eu-central-2") && !var.is_gov ? 1 : 0
  provider      = aws.eu-central-2
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "eu-central-2" {
  count     = contains(local.available_regions, "eu-central-2") && !var.is_gov ? 1 : 0
  provider  = aws.eu-central-2
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.eu-central-2.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "me-south-1" {
  count         = contains(local.available_regions, "me-south-1") && !var.is_gov ? 1 : 0
  provider      = aws.me-south-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "me-south-1" {
  count     = contains(local.available_regions, "me-south-1") && !var.is_gov ? 1 : 0
  provider  = aws.me-south-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.me-south-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "me-central-1" {
  count         = contains(local.available_regions, "me-central-1") && !var.is_gov ? 1 : 0
  provider      = aws.me-central-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "me-central-1" {
  count     = contains(local.available_regions, "me-central-1") && !var.is_gov ? 1 : 0
  provider  = aws.me-central-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.me-central-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_rule" "sa-east-1" {
  count         = contains(local.available_regions, "sa-east-1") && !var.is_gov ? 1 : 0
  provider      = aws.sa-east-1
  name          = local.rule_name
  event_pattern = local.event_pattern
  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_cloudwatch_event_target" "sa-east-1" {
  count     = contains(local.available_regions, "sa-east-1") && !var.is_gov ? 1 : 0
  provider  = aws.sa-east-1
  target_id = local.target_id
  arn       = var.eventbus_arn
  rule      = aws_cloudwatch_event_rule.sa-east-1.0.name
  role_arn  = aws_iam_role.this.arn
  depends_on = [
    aws_iam_role.this
  ]
}

