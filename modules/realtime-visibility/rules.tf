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
            "UploadPart",
            "PutObject",
            "InitiateReplication",
            "Publish"
          ]
        }
      ],
      "readOnly" : [
        false
      ]
    }
  })

  ro_rule_name = "cs-cloudtrail-events-readonly-rule"
  ro_event_pattern = jsonencode({
    source = [
      {
        "prefix" : "aws."
      }
    ],
    detail-type = [
      {
        "suffix" : "via CloudTrail"
      }
    ],
    detail = {
      "readOnly" : [
        true
      ]
    },
    "$or" : [
      {
        "detail" : {
          "eventName" : [
            {
              "anything-but" : [
                "Encrypt",
                "Decrypt",
                "GenerateDataKey",
                "Sign",
                "GetObject",
                "HeadObject",
                "ListObjects",
                "GetObjectTagging",
                "GetOjectAcl",
                "AssumeRole"
              ]
            }
          ]
        }
      },
      {
        "detail" : {
          "eventName" : [
            "AssumeRole"
          ],
          "userIdentity" : {
            "type" : [
              {
                "anything-but" : [
                  "AWSService"
                ]
              }
            ]
          }
        }
      }
    ]
  })

  # Get the raw event bus ARN (might be a single ARN or a comma-separated list)
  raw_eventbus_arn = var.is_gov_commercial ? "arn:${local.aws_partition}:events:${local.aws_region}:${local.account_id}:event-bus/default" : var.eventbus_arn

  # Split the ARN string at commas to handle multiple ARNs
  eventbus_arns = split(",", local.raw_eventbus_arn)

  eventbridge_role_arn = var.is_gov_commercial && var.is_primary_region ? null : "arn:${local.aws_partition}:iam::${local.account_id}:role/${var.eventbridge_role_name}"
}

# RW Event Rule
resource "aws_cloudwatch_event_rule" "rw" {
  name          = local.rule_name
  event_pattern = local.event_pattern
}

# Create an event target for each ARN in the list
resource "aws_cloudwatch_event_target" "rw" {
  count     = length(local.eventbus_arns)
  target_id = "${local.target_id}-${count.index}"
  arn       = trimspace(local.eventbus_arns[count.index])
  rule      = aws_cloudwatch_event_rule.rw.name
  role_arn  = local.eventbridge_role_arn

  depends_on = [
    aws_lambda_alias.eventbridge
  ]
}

# RO Event Rule
resource "aws_cloudwatch_event_rule" "ro" {
  name          = local.ro_rule_name
  event_pattern = local.ro_event_pattern
}

# Create an event target for each ARN in the list
resource "aws_cloudwatch_event_target" "ro" {
  count     = length(local.eventbus_arns)
  target_id = "${local.target_id}-${count.index}"
  arn       = trimspace(local.eventbus_arns[count.index])
  rule      = aws_cloudwatch_event_rule.ro.name
  role_arn  = local.eventbridge_role_arn

  depends_on = [
    aws_lambda_alias.eventbridge
  ]
}