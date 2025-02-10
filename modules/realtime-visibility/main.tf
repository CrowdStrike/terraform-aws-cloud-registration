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
  target_id = "CrowdStrikeCentralizeEvents"
  rule_name = "cs-cloudtrail-events-ioa-rule"
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

module "rules_us-east-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "us-east-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.us-east-1
  }
}

module "rules_us-east-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "us-east-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.us-east-2
  }
}

module "rules_us-west-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "us-west-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.us-west-1
  }
}

module "rules_us-west-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "us-west-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.us-west-2
  }
}

module "rules_af-south-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "af-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.af-south-1
  }
}

module "rules_ap-east-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-east-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-east-1
  }
}

module "rules_ap-south-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-south-1
  }
}

module "rules_ap-south-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-south-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-south-2
  }
}

module "rules_ap-southeast-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-southeast-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "rules_ap-southeast-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-southeast-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "rules_ap-southeast-3" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-southeast-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-southeast-3
  }
}

module "rules_ap-southeast-4" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-southeast-4") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-southeast-4
  }
}

module "rules_ap-northeast-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-northeast-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "rules_ap-northeast-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-northeast-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "rules_ap-northeast-3" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ap-northeast-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "rules_ca-central-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "ca-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.ca-central-1
  }
}

module "rules_eu-central-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-central-1
  }
}

module "rules_eu-west-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-west-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-west-1
  }
}

module "rules_eu-west-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-west-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-west-2
  }
}

module "rules_eu-west-3" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-west-3") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-west-3
  }
}

module "rules_eu-south-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-south-1
  }
}

module "rules_eu-south-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-south-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-south-2
  }
}

module "rules_eu-north-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-north-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-north-1
  }
}

module "rules_eu-central-2" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "eu-central-2") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.eu-central-2
  }
}

module "rules_me-south-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "me-south-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.me-south-1
  }
}

module "rules_me-central-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "me-central-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.me-central-1
  }
}
module "rules_sa-east-1" {
  source = "./modules/rules/"
  count  = contains(local.available_regions, "sa-east-1") && !var.is_gov ? 1 : 0

  eventbus_arn         = var.eventbus_arn
  eventbridge_role_arn = aws_iam_role.this.arn

  providers = {
    aws = aws.sa-east-1
  }
}

